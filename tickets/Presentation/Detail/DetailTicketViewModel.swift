import SwiftUI

class DetailTicketViewModel: ObservableObject {
    struct UIState {
        var ticket: Ticket!
        var error: AuthError?
    }

    @Published var uiState = UIState()

    private let ticketsUseCase: TicketsUseCase

    init(ticket: Ticket, ticketsUseCase: TicketsUseCase) {
        self.ticketsUseCase = ticketsUseCase
        self.uiState.ticket = ticket
    }
}
