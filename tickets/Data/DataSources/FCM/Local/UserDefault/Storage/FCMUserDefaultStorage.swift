import Foundation

class UserDefaultsTokenStorage: FCMTokenStorageProtocol {
    private let key = "firebaseToken"

    func save(_ token: String) {
        UserDefaults.standard.set(token, forKey: key)
    }

    func get() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
