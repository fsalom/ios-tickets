protocol TicketsRepositoryProtocol {
    func getAll() async throws -> [Ticket]
}
