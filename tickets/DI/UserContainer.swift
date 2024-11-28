class UserContainer {
    func makeUseCases() -> UserUseCases {
        let remote = UserRemoteDataSource(network: Config.shared.network)
        let userMemory = UserMemoryDataSource.shared
        UserFCMMemoryDataSource.configureShared(cacheTTL: 500)
        let fcmMemory = UserFCMMemoryDataSource.shared
        let repository = UserRepository(remote: remote, userMemory: userMemory, fcmMemory: fcmMemory)
        return UserUseCases(repository: repository)
    }
}
