import Foundation
import SwiftData

@Model
public final class Pattern: Identifiable, Codable, @unchecked Sendable {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var info: String
    public var filter: String
    @Relationship(deleteRule: .cascade) public var candles: [Candle]

    enum CodingKeys: String, CodingKey {
        case name, info, filter, candles
    }

    public init(id: UUID = UUID(), name: String, info: String, filter: String, candles: [Candle] = []) {
        self.id = id
        self.name = name
        self.info = info
        self.filter = filter
        self.candles = candles
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID() // Generate a new UUID for each pattern
        name = try container.decode(String.self, forKey: .name)
        info = try container.decode(String.self, forKey: .info)
        filter = try container.decode(String.self, forKey: .filter)
        candles = try container.decode([Candle].self, forKey: .candles)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(info, forKey: .info)
        try container.encode(filter, forKey: .filter)
        try container.encode(candles, forKey: .candles)
    }
}
