protocol StatsRepositoryProtocol {
    func getAll() async throws -> [Ticket]
}
