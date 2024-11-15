//
//  ChangeEmailViewModel.swift
//  Gula
//
//  Created by Jesu Castellano on 5/11/24.
//

import Foundation

class ChangeEmailViewModel: ObservableObject {
    
    struct UIState {
        var isEmailValid = true
        var sendButtonState: ButtonState = .normal
        var error: AuthError?
        var hasEmailBeenSent = false
        var emailErrorMessage = "wrongEmailFormat"
    }
    // TODO: - Create var to getCurrentEmail
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

    private func check(this email: String?) {
        if let email {
            uiState.isEmailValid = validationUseCase.validate(email: email) && !email.isEmpty
        } else {
            uiState.isEmailValid = false
        }
    }
    
    // TODO: - Create func to getCurrentEmail
    func changeEmail() {
        Task {
            do {
                try await authUseCase.changeEmail(email: email)
                await MainActor.run {
                    uiState.hasEmailBeenSent = true
                }
            } catch {
                await MainActor.run {
                    if let error = error as? AuthError {
                        uiState.error = error
                    }
                }
            }
        }
    }
}
