import TripleA

class TicketsRemoteDataSource: TicketsRemoteDataSourceProtocol {

    
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func getAll() async throws -> [Ticket] {        
        let endpoint = Endpoint(path: "https://tickets.rudo.es/api/v1/tickets/all", httpMethod: .get)
        let data = try await network.loadAuthorized(this: endpoint,
                                                    of: TicketDataDTO.self)

        return data.toDomain()
    }


    func getTicketsPerMonth() async throws -> [TicketsPerMonth] {
        let endpoint = Endpoint(path: "https://tickets.rudo.es/api/v1/tickets/by_month", httpMethod: .get)
        let ticketsPerMonth = try await network.loadAuthorized(this: endpoint,
                                                    of: [TicketsPerMonthDTO].self)

        return ticketsPerMonth.map { $0.toDomain() }
    }
}

fileprivate extension TicketsPerMonthDTO {
    func toDomain() -> TicketsPerMonth {
        return TicketsPerMonth(
            month: self.month,
            numberOfTickets: self.num_tickets,
            total: self.total,
            totalDifferencePreviousMonth: self.total_difference ?? 0.0,
            tickets: self.tickets.map { $0.toDomain()}
        )
    }
}

fileprivate extension TicketDataDTO {
    func toDomain() -> [Ticket] {
        return self.tickets.map { $0.toDomain() }
    }
}

fileprivate extension TicketDTO {
    func toDomain() -> Ticket {
        return Ticket(
            id_ticket: self.id_ticket,
            products: self.products.map { $0.toDomain() },
            total: self.total,
            iva: self.iva,
            date: self.date,
            email: self.email,
            location: self.location
        )
    }
}

fileprivate extension ProductDTO {
    func toDomain() -> Product {
        return Product(
            name: self.name,
            quantity: self.quantity,
            price_per_unit: self.price_per_unit,
            price: self.price,
            weight: self.weight
        )
    }
}
