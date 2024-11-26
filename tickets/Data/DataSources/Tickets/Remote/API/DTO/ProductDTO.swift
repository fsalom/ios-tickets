struct ProductDTO: Codable {
    var name: String
    var quantity: Int
    var price_per_unit: Float
    var price: Float
    var weight: String?
}
