import Foundation
import SwiftData

@Model
public final class Candle: @unchecked Sendable {
    @Attribute(.unique) public var id: UUID
    public var date: Date
    public var openPrice: Double
    public var closePrice: Double
    public var highPrice: Double
    public var lowPrice: Double
    public var value: Double?
    public var volume: Double?
    public var endDate: Date?
    public var ticker: String

    @Transient
    public var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }

    public init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, value: Double?, volume: Double?, endDate: Date?, ticker: String) {
        self.id = id
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.value = value
        self.volume = volume
        self.endDate = endDate
        self.ticker = ticker
    }
}
