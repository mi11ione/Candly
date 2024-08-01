import Foundation

public struct PatternDTO: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let info: String
    public let filter: String
    public let candles: [CandleDTO]

    public init(id: UUID, name: String, info: String, filter: String, candles: [CandleDTO]) {
        self.id = id
        self.name = name
        self.info = info
        self.filter = filter
        self.candles = candles
    }
}
