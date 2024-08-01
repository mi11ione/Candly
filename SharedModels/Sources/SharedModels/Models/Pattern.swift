import SwiftData
import Foundation

@Model
public final class Pattern {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var info: String
    public var filter: String
    @Relationship(deleteRule: .cascade) public var candles: [Candle]

    public init(id: UUID = UUID(), name: String, info: String, filter: String, candles: [Candle] = []) {
        self.id = id
        self.name = name
        self.info = info
        self.filter = filter
        self.candles = candles
    }
}

extension Pattern {
    public func toDTO() -> PatternDTO {
        PatternDTO(
            id: id,
            name: name,
            info: info,
            filter: filter,
            candles: candles.map { $0.toDTO() }
        )
    }
}
