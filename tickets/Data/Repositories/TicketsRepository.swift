class TicketsRepository: TicketsRepositoryProtocol {
    // MARK: - Properties
    private let remote: TicketsRemoteDataSourceProtocol

    // MARK: - Init
    init(remote: TicketsRemoteDataSourceProtocol) {
        self.remote = remote
    }

    func getAll() async throws -> [Ticket] {
        try await remote.getAll()
    }
}
