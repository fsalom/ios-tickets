class FCMUseCases {
    // MARK: - Properties
    var repository: FCMRepositoryProtocol

    // MARK: - Init
    init(repository: FCMRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Functions
    func save(token: String) {
        repository.save(token)
    }

    func get() -> String? {
        return repository.get()
    }
}
