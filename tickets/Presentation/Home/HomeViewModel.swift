import SwiftUI

class HomeViewModel: ObservableObject {
    struct UIState {
        var tickets = [Ticket]()
        var error: AuthError?
    }

    @Published var uiState = UIState()

    private let ticketsUseCase: TicketsUseCase

    init(ticketsUseCase: TicketsUseCase) {
        self.ticketsUseCase = ticketsUseCase
    }

    @MainActor
    func getAll() {
        Task {
            do {
                self.uiState.tickets = try await ticketsUseCase.getAll()
            } catch {
                self.uiState.error = .notVerified
            }
        }
    }
}

