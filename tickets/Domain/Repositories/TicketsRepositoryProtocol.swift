protocol TicketsRepositoryProtocol {
    func getAll() async throws -> [Ticket]
    func getTicketsPerMonth() async throws -> [TicketsPerMonth]
}
