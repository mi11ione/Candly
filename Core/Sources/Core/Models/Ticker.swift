import Foundation
import SwiftData

@Model
public final class Ticker: Identifiable, Codable, @unchecked Sendable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var subTitle: String
    public var price: Double
    public var priceChange: Double
    public var currency: String

    public init(id: UUID = UUID(), title: String, subTitle: String, price: Double, priceChange: Double, currency: String) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.price = price
        self.priceChange = priceChange
        self.currency = currency
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subTitle = try container.decode(String.self, forKey: .subTitle)
        price = try container.decode(Double.self, forKey: .price)
        priceChange = try container.decode(Double.self, forKey: .priceChange)
        currency = try container.decode(String.self, forKey: .currency)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(subTitle, forKey: .subTitle)
        try container.encode(price, forKey: .price)
        try container.encode(priceChange, forKey: .priceChange)
        try container.encode(currency, forKey: .currency)
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, subTitle, price, priceChange, currency
    }
}
