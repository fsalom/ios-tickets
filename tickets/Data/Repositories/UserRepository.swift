class UserRepository: UserRepositoryProtocol {
    // MARK: - Properties
    private let remote: UserRemoteDataSourceProtocol

    // MARK: - Init
    init(remote: UserRemoteDataSourceProtocol) {
        self.remote = remote
    }

    func get() async throws -> User {
        try await remote.get()
    }

    func update(fcmToken: String) async throws {
        try await remote.update(fcmToken: fcmToken)
    }
}
