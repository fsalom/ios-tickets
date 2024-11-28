import Foundation

struct TicketsPerMonth: Identifiable {
    var id: Int = Int(Date().timeIntervalSinceNow)
    var month: String
    var numberOfTickets: Int
    var total: Float
    var tickets: [Ticket]

    var totalWithFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale(identifier: "es_ES")
        if let formattedNumber = formatter.string(from: NSNumber(value: total)) {
            return formattedNumber
        } else {
            return "Error al formatear el número"
        }
    }

    var monthWithFormat: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM"
        inputFormatter.locale = Locale(identifier: "es_ES")

        if let date = inputFormatter.date(from: month) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM yyyy"
            outputFormatter.locale = Locale(identifier: "es_ES")

            let formattedDate = outputFormatter.string(from: date)
            return formattedDate.capitalized
        } else {
            return "Error: No se pudo convertir la fecha."
        }
    }
}
