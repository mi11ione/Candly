import Foundation
import SwiftData

@Model
public final class Candle: Identifiable, Codable, @unchecked Sendable {
    @Attribute(.unique) public var id: UUID
    public var date: Date
    public var openPrice: Double
    public var closePrice: Double
    public var highPrice: Double
    public var lowPrice: Double
    public var ticker: String

    public var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }

    public init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, ticker: String) {
        self.id = id
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.ticker = ticker
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        openPrice = try container.decode(Double.self, forKey: .openPrice)
        closePrice = try container.decode(Double.self, forKey: .closePrice)
        highPrice = try container.decode(Double.self, forKey: .highPrice)
        lowPrice = try container.decode(Double.self, forKey: .lowPrice)
        ticker = try container.decode(String.self, forKey: .ticker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(openPrice, forKey: .openPrice)
        try container.encode(closePrice, forKey: .closePrice)
        try container.encode(highPrice, forKey: .highPrice)
        try container.encode(lowPrice, forKey: .lowPrice)
        try container.encode(ticker, forKey: .ticker)
    }

    private enum CodingKeys: String, CodingKey {
        case id, date, openPrice, closePrice, highPrice, lowPrice, ticker
    }
}
