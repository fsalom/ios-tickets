class HomeViewBuilder {
    func build() -> HomeView {
        let ticketsRemote = TicketsRemoteDataSource(network: Config.shared.network)
        let ticketsRepository = TicketsRepository(remote: ticketsRemote)
        let ticketsUseCase = TicketsUseCase(repository: ticketsRepository)
        let viewModel = HomeViewModel(ticketsUseCase: ticketsUseCase)
        let view = HomeView(viewModel: viewModel)
        return view
    }
}

