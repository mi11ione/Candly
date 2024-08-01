import Foundation
import SwiftData

@Model
public final class Ticker {
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
}

public extension Ticker {
    func toDTO() -> TickerDTO {
        TickerDTO(id: id, title: title, subTitle: subTitle, price: price, priceChange: priceChange, currency: currency)
    }

    convenience init(from dto: TickerDTO) {
        self.init(id: dto.id, title: dto.title, subTitle: dto.subTitle, price: dto.price, priceChange: dto.priceChange, currency: dto.currency)
    }
}
