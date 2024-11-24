class StatsRepository: StatsRepositoryProtocol {
    // MARK: - Properties
    private let remote: StatsRemoteDataSourceProtocol

    // MARK: - Init
    init(remote: StatsRemoteDataSourceProtocol) {
        self.remote = remote
    }

    func getAll() async throws -> [Ticket] {
        try await remote.getAll()
    }
}
