//
//  LoginViewModel.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 4/7/24.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn

enum LoginCalls {
    case loginWithApple
    case loginWithGoogle
    case resendLinkVerificationEmail
    case login
}

class LoginViewModel: NSObject, ObservableObject {
    struct UIState {
        var isEmailValid = false
        var isPasswordValid = true
        var error: AuthError?
        var showToast = false
        var emailErrorMessage = "wrongEmailFormat"
        var passwordErrorMessage = ""
        var isLoginSuccessful = false
        var allFieldsAreValid = false
    }
    
    @Published var email: String = "" {
        didSet {
            check(this: email)
        }
    }
    @Published var password: String = "" {
        didSet {
            checkIfReadyToLogin()
        }
    }
    @Published var uiState = UIState()
    @Published var lastCall: LoginCalls = .login
    
    private let validationUseCase: ValidationUseCaseProtocol
    private let authUseCase: AuthUseCaseProtocol
    
    init(validationUseCase: ValidationUseCaseProtocol, authUseCase: AuthUseCaseProtocol) {
        self.validationUseCase = validationUseCase
        self.authUseCase = authUseCase
    }
    
    @MainActor
    func login() {
        Task {
            lastCall = .login

            do {
                try await authUseCase.login(with: email, and: password)
                uiState.isLoginSuccessful = true
            } catch let error as AuthError? {
                uiState.error = error
            }
        }
    }
    
    @MainActor
    func loginWithGoogle() {
        Task {
            lastCall = .loginWithGoogle

            do {
                if let rootViewController = getRootViewController(),
                   let result = try? await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController),
                   let token = result.user.idToken?.tokenString {
                    try await authUseCase.loginWithGoogle(token: token)
                } else {
                    throw AppError.generalError
                }
            } catch let error as AuthError? {
                uiState.error = error
            }
        }
    }

    @MainActor
    func resendLinkVerificationEmail() {
        Task {
            lastCall = .resendLinkVerificationEmail

            do {
                try await authUseCase.resendLinkVerification(email: email)
                uiState.showToast = true
            } catch let error as AuthError? {
                uiState.error = error
            }
        }
    }

    @MainActor func tryCallAgain() {
        switch lastCall {
        case .login:
            login()
        case .loginWithGoogle:
            loginWithGoogle()
        case .resendLinkVerificationEmail:
            resendLinkVerificationEmail()
        case .loginWithApple:
            loginWithApple()
        }
    }
    
    private func checkIfReadyToLogin()  {
        uiState.allFieldsAreValid = uiState.isEmailValid && !email.isEmpty && !password.isEmpty
    }
    
    private func check(this email: String?) {
        guard let email, !email.isEmpty else { return }
        uiState.isEmailValid = validationUseCase.validate(email: email)
        
        checkIfReadyToLogin()
    }
    
    private func getRootViewController() -> UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
}

//MARK: - Apple Login
extension LoginViewModel: ASAuthorizationControllerDelegate {
    func loginWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    @MainActor
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let authorizationCode = appleIDCredential.authorizationCode,
           let code = String(data: authorizationCode, encoding: .utf8) {
            loginWithApple(code: code)
        }
    }
    
    @MainActor
    private func loginWithApple(code: String) {
        Task {
            lastCall = .loginWithApple

            do {
                try await authUseCase.loginWithApple(code: code)
            } catch {
                if let error = error as? AuthError {
                    uiState.error = error
                }
            }
        }
    }
}
