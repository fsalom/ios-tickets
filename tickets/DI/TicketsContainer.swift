class TicketsContainer {
    func makeUseCases() -> TicketsUseCases {
        let remote = TicketsRemoteDataSource(network: Config.shared.network)
        TicketsMemoryDataSource.configureShared(cacheTTL: 10)
        let memory = TicketsMemoryDataSource.shared
        let repository = TicketsRepository(remote: remote, memory: memory)
        return TicketsUseCases(repository: repository)
    }
}
