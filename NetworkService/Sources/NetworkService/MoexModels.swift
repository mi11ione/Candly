public struct MoexTickers: Decodable {
    public let securities: Securities

    public struct Securities: Decodable {
        public let columns: [String]
        public let data: [[MoexTicker]]
    }
}

public enum MoexTicker: Decodable {
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
}

public struct MoexCandles: Decodable {
    public let candles: Candles

    public struct Candles: Decodable {
        public let columns: [String]
        public let data: [[MoexTicker]]
    }
}
