struct TicketDTO: Codable {
    var id_ticket: String
    var products: [ProductDTO]
    var total: Float
    var iva: Float
    var date: String
    var email: String
    var location: String?
}

