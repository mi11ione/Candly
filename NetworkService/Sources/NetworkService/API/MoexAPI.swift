import Foundation

public enum MoexAPI {
    private static let scheme = "https"
    private static let host = "iss.moex.com"
    private static let candlePath = "/iss/engines/stock/markets/shares/boards/TQBR/securities"

    public enum Endpoint {
        case allTickers
        case candles(String)

        var path: String {
            switch self {
            case .allTickers:
                "\(candlePath).json"
            case let .candles(ticker):
                "\(candlePath)/\(ticker)/candles.json"
            }
        }

        public func url(queryItems: [URLQueryItem]? = nil) -> URL? {
            var components = URLComponents()
            components.scheme = MoexAPI.scheme
            components.host = MoexAPI.host
            components.path = path
            components.queryItems = queryItems
            return components.url
        }
    }
}
