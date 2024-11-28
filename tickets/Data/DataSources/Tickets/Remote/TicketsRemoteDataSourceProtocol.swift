protocol TicketsRemoteDataSourceProtocol {
    func getAll() async throws -> [Ticket]
    func getTicketsPerMonth() async throws -> [TicketsPerMonth]
}
