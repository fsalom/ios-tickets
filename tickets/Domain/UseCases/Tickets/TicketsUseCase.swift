class TicketsUseCase {
    // MARK: - Properties
    var repository: TicketsRepositoryProtocol

    // MARK: - Init
    init(repository: TicketsRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Functions
    func getAll() async throws -> [Ticket] {
        try await repository.getAll()
    }
}
