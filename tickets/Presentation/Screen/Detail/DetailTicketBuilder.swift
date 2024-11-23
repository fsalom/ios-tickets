class DetailTicketBuilder {
    func build(with ticket: Ticket) -> DetailTicketView {
        let ticketsUseCase = TicketsContainer().makeUseCases()
        let viewModel = DetailTicketViewModel(ticket: ticket, ticketsUseCase: ticketsUseCase)
        let view = DetailTicketView(viewModel: viewModel)
        return view
    }
}
