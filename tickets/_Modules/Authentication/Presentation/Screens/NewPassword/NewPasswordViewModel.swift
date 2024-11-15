//
//  NewPasswordViewModel.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 22/7/24.
//

import Foundation

class NewPasswordViewModel: ObservableObject {
    // MARK: UIState
    struct UIState {
        var hasChangePasswordSucceeded = false
        var arePasswordsEqual = true
        var isPasswordValid = true
        var passwordErrorMessage = "wrongPhoneFormat"
        var areAllFieldsOk = false
        var error: AuthError?
    }
    
    // MARK: Properties
    var userId: String?
    @Published var uiState = UIState()
    @Published var password: String = "" {
        didSet {
            checkPassword()
        }
    }
    @Published var repeatPassword: String = "" {
        didSet {
            checkIfPasswordsMatch()
        }
    }
    private let validationUseCase: ValidationUseCaseProtocol
    private let authUseCase: AuthUseCaseProtocol
    
    // MARK: Init
    init(userId: String?, validationUseCase: ValidationUseCaseProtocol, authUseCase: AuthUseCaseProtocol) {
        self.userId = userId
        self.validationUseCase = validationUseCase
        self.authUseCase = authUseCase
    }
    
    // MARK: Functions
    @MainActor
    func changePassword() {
        Task {
            do {
                if let userId {
                    try await authUseCase.changePassword(password: password, id: userId)
                } else {
                    try await authUseCase.updatePassword(with: password)
                }
                uiState.hasChangePasswordSucceeded = true
            } catch {
                if let error = error as? AuthError {
                    uiState.error = error
                }
            }
        }
    }
    
    private func checkPassword() {
        uiState.isPasswordValid = validationUseCase.validate(password: password)
    }
    
    func checkIfReadyToChangePassword() {
        uiState.areAllFieldsOk = uiState.isPasswordValid && !password.isEmpty && !repeatPassword.isEmpty && uiState.arePasswordsEqual
    }
    
    private func checkIfPasswordsMatch(){
        uiState.arePasswordsEqual = password == repeatPassword
    }
}
