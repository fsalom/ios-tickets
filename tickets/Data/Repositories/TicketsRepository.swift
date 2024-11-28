class TicketsRepository: TicketsRepositoryProtocol {
    // MARK: - Properties
    private let remote: TicketsRemoteDataSourceProtocol
    private let memory: TicketsMemoryDataSource

    // MARK: - Init
    init(remote: TicketsRemoteDataSourceProtocol,
         memory: TicketsMemoryDataSource) {
        self.remote = remote
        self.memory = memory
    }

    func getAll() async throws -> [Ticket] {
        do {
            return try memory.get()
        } catch {
            let tickets = try await remote.getAll()
            memory.save(value: tickets)
            return tickets
        }
    }

    func getTicketsPerMonth() async throws -> [TicketsPerMonth] {
        return try await remote.getTicketsPerMonth()
    }
}
