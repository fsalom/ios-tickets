protocol FCMLocalDataSourceProtocol {
    func save(_ token: String)
    func get() -> String?
}
