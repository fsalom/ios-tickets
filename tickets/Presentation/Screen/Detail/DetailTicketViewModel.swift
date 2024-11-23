import SwiftUI

class DetailTicketViewModel: ObservableObject {
    struct UIState {
        var ticket: Ticket!
        var error: AuthError?
    }

    @Published var uiState = UIState()

    private let ticketsUseCase: TicketsUseCases

    init(ticket: Ticket, ticketsUseCase: TicketsUseCases) {
        self.ticketsUseCase = ticketsUseCase
        self.uiState.ticket = ticket
    }
}
