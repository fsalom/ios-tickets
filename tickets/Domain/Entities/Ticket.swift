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

    var dateWithFormat: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        inputFormatter.locale = Locale(identifier: "es_ES")

        if let date = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d 'de' MMMM 'de' yyyy"
            outputFormatter.locale = Locale(identifier: "es_ES")

            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        } else {
            return "Error: No se pudo convertir la fecha."
        }
    }
}
