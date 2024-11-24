class FCMRepository: FCMRepositoryProtocol {
    // MARK: - Properties
    var datasource: FCMLocalDataSourceProtocol

    // MARK: - Init
    init(datasource: FCMLocalDataSourceProtocol) {
        self.datasource = datasource
    }

    // MARK: - Functions
    func save(_ token: String) {
        datasource.save(token)
    }

    func get() -> String? {
        return datasource.get()
    }
}
