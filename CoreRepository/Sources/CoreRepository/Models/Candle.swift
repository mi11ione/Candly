import Foundation
import SharedModels
import SwiftData

@Model
public final class Candle {
    @Attribute(.unique) public var id: UUID
    public var date: Date
    public var openPrice: Double
    public var closePrice: Double
    public var highPrice: Double
    public var lowPrice: Double
    public var ticker: String

    public init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, ticker: String) {
        self.id = id
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.ticker = ticker
    }

    public func toDTO() -> CandleDTO {
        CandleDTO(id: id, date: date, openPrice: openPrice, closePrice: closePrice, highPrice: highPrice, lowPrice: lowPrice)
    }

    public static func from(dateString: String) -> Date {
        ISO8601DateFormatter().date(from: dateString) ?? Date()
    }

    public convenience init(from dto: CandleDTO, ticker: String) {
        self.init(id: dto.id, date: dto.date, openPrice: dto.openPrice, closePrice: dto.closePrice, highPrice: dto.highPrice, lowPrice: dto.lowPrice, ticker: ticker)
    }
}
