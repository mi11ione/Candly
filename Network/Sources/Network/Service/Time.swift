import Foundation

public enum Time: String, Sendable {
    case hour, day, week, month

    public var id: String { rawValue }

    public var queryItem: URLQueryItem {
        URLQueryItem(name: "interval", value: intervalValue)
    }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "from", value: Date().addingTimeInterval(-86400 * 7).ISO8601Format()),
            URLQueryItem(name: "till", value: Date().ISO8601Format()),
            URLQueryItem(name: "interval", value: intervalValue),
        ]
    }

    private var intervalValue: String {
        switch self {
        case .hour: "60"
        case .day: "24"
        case .week: "7"
        case .month: "31"
        }
    }
}

public struct CandleKey {
    private let ticker: String
    private let time: Time

    public init(ticker: String, time: Time) {
        self.ticker = ticker
        self.time = time
    }
}
