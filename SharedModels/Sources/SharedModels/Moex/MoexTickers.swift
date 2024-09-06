import Foundation
import SwiftData

@Model
public final class MoexTickers: Identifiable, Codable, @unchecked Sendable {
    @Attribute(.unique) public var id: UUID
    public var securities: Securities

    public init(id: UUID = UUID(), securities: Securities) {
        self.id = id
        self.securities = securities
    }

    public struct Securities: Codable, Sendable {
        public let columns: [String]
        public let data: [[MoexTicker]]

        public init(columns: [String], data: [[MoexTicker]]) {
            self.columns = columns
            self.data = data
        }
    }

    public enum CodingKeys: String, CodingKey {
        case securities
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        securities = try container.decode(Securities.self, forKey: .securities)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(securities, forKey: .securities)
    }
}
