//
//  RegisterConfirmationVIewModel.swift
//  Gula
//
//  Created by María on 1/8/24.
//

import Foundation

class RegisterConfirmationViewModel: ObservableObject {
    // MARK: - UIState
    struct UIState {
        var sendEmailSucceeded: Bool = false
        var error: AuthError?
    }
    // MARK: - Properties
    var email: String
    private let authUseCase: AuthUseCaseProtocol
    @Published var uiState = UIState()
    
    // MARK: - Init
    init(email: String, authUseCase: AuthUseCaseProtocol) {
        self.email = email
        self.authUseCase = authUseCase
    }
    
    // MARK: - Functions
    @MainActor
    func resendVerificationEmail() {
        Task {
            do {
                uiState.sendEmailSucceeded = false
                try await authUseCase.resendLinkVerification(email: email)
                uiState.sendEmailSucceeded = true
            } catch let error as AuthError? {
                uiState.error = error
            }
        }
    }
}
