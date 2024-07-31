import Foundation
import SwiftData

@Model
final class Candle: Identifiable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var openPrice: Double
    var closePrice: Double
    var highPrice: Double
    var lowPrice: Double

    init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double) {
        self.id = id
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
    }
}

extension Candle {
    var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }

    static func from(dateString: String) -> Date {
        ISO8601DateFormatter().date(from: dateString) ?? Date()
    }
}
