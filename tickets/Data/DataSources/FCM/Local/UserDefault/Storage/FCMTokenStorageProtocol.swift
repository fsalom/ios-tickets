protocol FCMTokenStorageProtocol {
    func save(_ token: String)
    func get() -> String?
}
