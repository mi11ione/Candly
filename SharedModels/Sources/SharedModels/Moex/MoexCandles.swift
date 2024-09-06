import Foundation
import SwiftData

@Model
public final class MoexCandles: Identifiable, Codable, @unchecked Sendable {
    @Attribute(.unique) public var id: UUID
    public var candles: Candles

    public init(id: UUID = UUID(), candles: Candles) {
        self.id = id
        self.candles = candles
    }

    public struct Candles: Codable, Sendable {
        public let columns: [String]
        public let data: [[MoexTicker]]

        public init(columns: [String], data: [[MoexTicker]]) {
            self.columns = columns
            self.data = data
        }
    }

    public enum CodingKeys: String, CodingKey {
        case candles
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        candles = try container.decode(Candles.self, forKey: .candles)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(candles, forKey: .candles)
    }
}
