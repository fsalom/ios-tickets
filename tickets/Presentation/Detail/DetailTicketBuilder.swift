class DetailTicketBuilder {
    func build(with ticket: Ticket) -> DetailTicketView {
        let ticketsRemote = TicketsRemoteDataSource(network: Config.shared.network)
        let ticketsRepository = TicketsRepository(remote: ticketsRemote)
        let ticketsUseCase = TicketsUseCase(repository: ticketsRepository)
        let viewModel = DetailTicketViewModel(ticket: ticket, ticketsUseCase: ticketsUseCase)
        let view = DetailTicketView(viewModel: viewModel)
        return view
    }
}
