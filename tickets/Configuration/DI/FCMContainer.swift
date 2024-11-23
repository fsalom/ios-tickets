class FCMContainer {
    func makeUseCases() -> FCMUseCases {
        let tokenStorage = UserDefaultsTokenStorage()
        let datasource = FCMUserDefaultDataSource(storage: tokenStorage)
        let repository = FCMRepository(datasource: datasource)
        return FCMUseCases(repository: repository)
    }
}
