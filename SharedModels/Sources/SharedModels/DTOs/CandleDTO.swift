import Foundation

public struct CandleDTO: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let date: Date
    public let openPrice: Double
    public let closePrice: Double
    public let highPrice: Double
    public let lowPrice: Double

    public init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double) {
        self.id = id
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
    }

    public var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }
}
