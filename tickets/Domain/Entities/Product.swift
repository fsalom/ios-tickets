import Foundation

struct Product: Identifiable {
    var id = UUID().uuidString
    var name: String
    var quantity: Int
    var price_per_unit: Float
    var price: Float
    var weight: String?

    var priceWithFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale(identifier: "es_ES")
        if let formattedNumber = formatter.string(from: NSNumber(value: price)) {
            return formattedNumber
        } else {
            return "Error al formatear el número"
        }
    }
}
