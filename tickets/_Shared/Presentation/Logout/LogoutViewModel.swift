//
//  LogoutViewModel.swift
//  Gula
//
//  Created by Axel Pérez Gaspar on 29/8/24.
//

import Foundation
import SwiftUI

final class LogoutViewModel: ObservableObject {
    private let useCase: AuthUseCaseProtocol
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    @MainActor
    func logout() {
        Task {
            do {
                try await useCase.logout()
            } catch {
                
            }
        }
    }
}
