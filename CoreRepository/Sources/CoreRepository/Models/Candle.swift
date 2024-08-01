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

    public init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double) {
        self.id = id
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
    }

    public func toDTO() -> CandleDTO {
        CandleDTO(
            id: id,
            date: date,
            openPrice: openPrice,
            closePrice: closePrice,
            highPrice: highPrice,
            lowPrice: lowPrice
        )
    }

    public static func from(dateString: String) -> Date {
        ISO8601DateFormatter().date(from: dateString) ?? Date()
    }
}
