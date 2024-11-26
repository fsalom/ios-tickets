import TripleA

class FCMUserDefaultDataSource: FCMLocalDataSourceProtocol {
    private let storage: FCMTokenStorageProtocol

    init(storage: FCMTokenStorageProtocol) {
        self.storage = storage
    }

    func save(_ token: String) {
        self.storage.save(token)
    }

    func get() -> String? {
        return self.storage.get()
    }
}
