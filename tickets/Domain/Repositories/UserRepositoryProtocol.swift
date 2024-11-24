protocol UserRepositoryProtocol {
    func get() async throws -> User
    func update(fcmToken: String) async throws
}
