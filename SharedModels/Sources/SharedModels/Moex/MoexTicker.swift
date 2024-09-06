import Foundation

public enum MoexTicker: Codable, Sendable {
    case double(Double)
    case string(String)
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
        } else if let x = try? container.decode(String.self) {
            self = .string(x)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(MoexTicker.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MoexTicker"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .double(x):
            try container.encode(x)
        case let .string(x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}
