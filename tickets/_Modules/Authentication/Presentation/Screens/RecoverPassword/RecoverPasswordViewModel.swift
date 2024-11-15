//
//  RecoverPasswordViewModel.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 17/7/24.
//

import Foundation

class RecoverPasswordViewModel: ObservableObject {
    // MARK: - UIState
    struct UIState {
        var isEmailValid = false
        var emailErrorMessage = "wrongEmailFormat"
        var sendButtonState: ButtonState = .disabled
        var error: AuthError?
        var hasEmailBeenSent = false
    }
    
    // MARK: - Properties
    @Published var email: String = "" {
        didSet {
            check(this: email)
        }
    }
    private let validationUseCase: ValidationUseCaseProtocol
    private let authUseCase: AuthUseCaseProtocol
    @Published var uiState = UIState()
    
    // MARK: - Init
    init(validationUseCase: ValidationUseCaseProtocol, authUseCase: AuthUseCaseProtocol) {
        self.validationUseCase = validationUseCase
        self.authUseCase = authUseCase
    }
    
    // MARK: - Functions
    @MainActor
    func recoverPassword() {
        Task {
            do {
                try await authUseCase.recoverPassword(with: email)
                uiState.hasEmailBeenSent = true
            } catch {
                if let error = error as? AuthError {
                    uiState.error = error
                }
            }
        }
    }
    
    private func checkIfReadyToSend()  {
        let isButtonDisabled = !uiState.isEmailValid || email.isEmpty
        uiState.sendButtonState = isButtonDisabled ? .disabled : .normal
    }
    
    private func check(this email: String?) {
        guard let email, !email.isEmpty else { return }
        uiState.isEmailValid = validationUseCase.validate(email: email)
        
        checkIfReadyToSend()
    }
}
