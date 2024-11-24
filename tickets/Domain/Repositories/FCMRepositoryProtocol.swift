protocol FCMRepositoryProtocol {
    func save(_ token: String)
    func get() -> String?
}
