class StatsUseCases {
    // MARK: - Properties
    var repository: StatsRepositoryProtocol

    // MARK: - Init
    init(repository: StatsRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Functions
    func getAll() async throws -> [Ticket] {
        try await repository.getAll()
    }
}
