import Foundation

struct Ticket: Identifiable {
    var id = UUID().uuidString
    var id_ticket: String
    var products: [Product]
    var total: Float
    var iva: Float
    var date: String
    var email: String
    var location: String?
}
