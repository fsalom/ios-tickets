//
//  VerifyPasswordViewModel.swift
//  Gula
//
//  Created by Adrian Prieto Villena on 4/11/24.
//

import Foundation

class VerifyPasswordViewModel: ObservableObject {
    struct UIState {
        var error: AuthError?
        var isValidPassword = true
        var isVerified = false
        var hasStartTyping = false
    }
    // MARK: - Properties
    @Published var uiState = UIState()
    @Published var password: String = ""
    @Published var passwordErrorMessage = "wrongPassword"
    private let authUseCase: AuthUseCaseProtocol
    private let validationUseCase: ValidationUseCaseProtocol

    init(authUseCase: AuthUseCaseProtocol, validationUseCase: ValidationUseCaseProtocol) {
        self.authUseCase = authUseCase
        self.validationUseCase = validationUseCase
    }

    func verifyPassword() {
        Task {
            do {
                try await authUseCase.validatePassword(password)
                await MainActor.run {
                    uiState.isVerified = true
                    uiState.isValidPassword = true
                }
            } catch {
                await MainActor.run {
                    uiState.isVerified = false
                    if let error = error as? AuthError {
                        uiState.error = error
                    }
                }
            }
        }
    }
}
