//
//  RegisterViewModel.swift
//  Gula
//
//  Created by María on 31/7/24.
//

import Foundation

class RegisterViewModel: ObservableObject {
    struct UIState {
        var isValidEmail = false
        var isValidPassword = false
        var isValidName = false
        var isValidRepeatPassword = false
        var emailErrorMessage: String = "wrongEmailFormat"
        var passwordErrorMessage: String = "wrongPasswordFormat"
        var usernameErrorMessage: String = ""
        var error: AuthError?
        var allFieldsOK = false
        var createAccountSucceeded = false
    }

    // MARK: - Properties
    @Published var email: String = "" {
        didSet {
            checkEmail(email)
        }
    }
    @Published var password: String = "" {
        didSet {
            checkPassword(password)
        }
    }
    @Published var repeatPassword: String = "" {
        didSet {
            checkIfPasswordsMatch(this: repeatPassword)
        }
    }
    @Published var fullName: String = "" {
        didSet {
            checkName(this: fullName)
        }
    }
    @Published var uiState = UIState()    
    private let validationUseCase: ValidationUseCaseProtocol
    private let authUseCase: AuthUseCaseProtocol

    // MARK: - Init
    init(validationUseCase: ValidationUseCaseProtocol, authUseCase: AuthUseCaseProtocol) {
        self.validationUseCase = validationUseCase
        self.authUseCase = authUseCase
    }
    
    // MARK: - Functions
    @MainActor
    func createAccount() {
        Task {
            do {
                try await authUseCase.createAccount(fullName: fullName, email: email, password: password)
                uiState.createAccountSucceeded = true
            } catch {
                if  let error = error as? AuthError {
                    uiState.createAccountSucceeded = false
                    uiState.error = error
                }
            }
        }
    }
    
    private func checkRegisterFields() {
        let isLoginDisabled = !uiState.isValidEmail || email.isEmpty || password.isEmpty || !uiState.isValidName || repeatPassword.isEmpty || !uiState.isValidPassword || !uiState.isValidRepeatPassword
        uiState.allFieldsOK = !isLoginDisabled
    }
    
    private func checkEmail(_ email: String) {
        guard !email.isEmpty else { return }
        uiState.isValidEmail = validationUseCase.validate(email: email)
        checkRegisterFields()
    }
    
    private func checkPassword(_ password: String) {
        guard !password.isEmpty else { return }
        uiState.isValidPassword = validationUseCase.validate(password: password)
        checkRegisterFields()
    }
    
    private func checkName(this name: String) {
        uiState.isValidName = !name.isEmpty
        checkRegisterFields()
    }
    
    private func checkIfPasswordsMatch(this repeatPassword: String) {
        uiState.isValidRepeatPassword = repeatPassword == password
        checkRegisterFields()
    }
}
