class UserContainer {
    func makeUseCases() -> UserUseCases {
        let remote = UserRemoteDataSource(network: Config.shared.network)
        let repository = UserRepository(remote: remote)
        return UserUseCases(repository: repository)
    }
}
