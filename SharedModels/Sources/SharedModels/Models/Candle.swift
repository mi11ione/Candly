import Foundation
import SwiftData

@Model
public final class Candle: Identifiable, @unchecked Sendable {
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

    public var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }
}

public extension Candle {
    static func from(dateString: String) -> Date {
        ISO8601DateFormatter().date(from: dateString) ?? Date()
    }
}
