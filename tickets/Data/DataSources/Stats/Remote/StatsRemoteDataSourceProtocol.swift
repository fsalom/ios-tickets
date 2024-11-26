protocol StatsRemoteDataSourceProtocol {
    func getAll() async throws -> [Ticket]
}
