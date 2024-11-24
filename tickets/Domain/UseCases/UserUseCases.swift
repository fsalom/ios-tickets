class UserUseCases {
    // MARK: - Properties
    var repository: UserRepositoryProtocol

    // MARK: - Init
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Functions
    func get() async throws -> User {
        try await repository.get()
    }

    func update(fcmToken: String) async throws {
        try await self.repository.update(fcmToken: fcmToken)
    }
}
