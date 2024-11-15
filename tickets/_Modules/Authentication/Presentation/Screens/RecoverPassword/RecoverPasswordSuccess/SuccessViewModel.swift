//
//  SuccessViewModel.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 18/7/24.
//

import Foundation

class SuccessViewModel: ObservableObject {
    
    struct UIState {
        var isEmailValid = false
        var sendButtonState: ButtonState = .disabled
        var error: AuthError?
        var hasEmailBeenSent = false
    }
    
    var action: (() -> Void)?
    private let authUseCase: AuthUseCaseProtocol
    
    @Published var uiState = UIState()
    
    init(useCase: AuthUseCaseProtocol) {
        self.authUseCase = useCase
    }
    
    @MainActor
    func change(email: String) {
        Task {
            do {
                try await authUseCase.changeEmail(email: email)
                uiState.hasEmailBeenSent = true
            } catch {
                if let error = error as? AuthError {
                    uiState.error = error
                }
            }
        }
    }
}
