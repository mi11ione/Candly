import Foundation
import SwiftData

@Model
final class Pattern: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var info: String
    var filter: String
    var candles: [Candle]

    init(id: UUID = UUID(), name: String, info: String, filter: String, candles: [Candle]) {
        self.id = id
        self.name = name
        self.info = info
        self.filter = filter
        self.candles = candles
    }
}

extension Pattern {
    var yAxisDomain: ClosedRange<Double> {
        let prices = candles.flatMap { [$0.lowPrice, $0.highPrice] }
        guard let min = prices.min(), let max = prices.max() else { return 0 ... 100 }
        let padding = (max - min) * 0.15
        return (min - padding) ... (max + padding)
    }
}
