import SwiftData
import Foundation

@Model
final class Pattern: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var info: String
    var filter: String
    @Relationship(deleteRule: .cascade) var candles: [Candle]

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

extension Pattern {
    func toDTO() -> PatternDTO {
        PatternDTO(id: id, name: name, info: info, filter: filter, candles: candles.map { $0.toDTO() })
    }

    convenience init(from dto: PatternDTO) {
        self.init(id: dto.id, name: dto.name, info: dto.info, filter: dto.filter, candles: dto.candles.map { Candle(from: $0) })
    }
}
