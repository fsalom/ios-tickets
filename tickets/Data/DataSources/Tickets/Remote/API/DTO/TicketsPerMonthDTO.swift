struct TicketsPerMonthDTO: Codable {
    var num_tickets: Int
    var total: Float
    var tickets: [TicketDTO]
    var month: String
}
