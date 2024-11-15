//
//  DeleteAccountViewModel.swift
//  Gula
//
//  Created by Jorge on 29/10/24.
//

import Foundation

class DeleteAccountViewModel: ObservableObject {
    struct UIState {
        var error: AuthError?
        var navigateToHome = false
    }

    @Published var uiState = UIState()
    private let authUseCase: AuthUseCaseProtocol

    init(authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
    }

    @MainActor
    func deleteAccount() {
        Task {
            do {
                try await authUseCase.deleteAccount()
                uiState.navigateToHome = true
            }  catch let error as AuthError? {
                uiState.error = error
            }
        }
    }
}
