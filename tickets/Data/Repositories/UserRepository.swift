class UserRepository: UserRepositoryProtocol {
    // MARK: - Properties
    private let remote: UserRemoteDataSourceProtocol
    private let userMemory: UserMemoryDataSource
    private let fcmMemory: UserFCMMemoryDataSource

    // MARK: - Init
    init(remote: UserRemoteDataSourceProtocol,
         userMemory: UserMemoryDataSource,
         fcmMemory: UserFCMMemoryDataSource) {
        self.remote = remote
        self.userMemory = userMemory
        self.fcmMemory = fcmMemory
    }

    func get() async throws -> User {
        do {
            return try userMemory.get()
        } catch {
            let user = try await remote.get()
            userMemory.save(value: user)
            return user
        }
    }

    func update(fcmToken: String) async throws {
        do {
            _ = try fcmMemory.get()
        } catch {
            _ = try await remote.update(fcmToken: fcmToken)
            fcmMemory.save(value: fcmToken)
        }
    }
}
