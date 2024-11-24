import Foundation

struct User: Identifiable {
    var id = UUID().uuidString
    var email: String
}
