class TicketsContainer {
    func makeUseCases() -> TicketsUseCases {
        let remote = TicketsRemoteDataSource(network: Config.shared.network)
        let repository = TicketsRepository(remote: remote)
        return TicketsUseCases(repository: repository)
    }
}
