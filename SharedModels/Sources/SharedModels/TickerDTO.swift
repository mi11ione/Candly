import Foundation

public struct TickerDTO: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let subTitle: String
    public let price: Double
    public let priceChange: Double
    public let currency: String

    public init(id: UUID = UUID(), title: String, subTitle: String, price: Double, priceChange: Double, currency: String) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.price = price
        self.priceChange = priceChange
        self.currency = currency
    }
}
