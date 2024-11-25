protocol TicketsRemoteDataSourceProtocol {
    func getAll() async throws -> [Ticket]
}
