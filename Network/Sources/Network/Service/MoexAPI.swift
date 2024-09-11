import Foundation

enum MoexAPI {
    static let scheme = "https"
    static let host = "iss.moex.com"
    static let candlePath = "/iss/engines/stock/markets/shares/boards/TQBR/securities"

    enum Endpoint {
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

        func url(queryItems: [URLQueryItem]? = nil) -> URL? {
            var components = URLComponents()
            components.scheme = MoexAPI.scheme
            components.host = MoexAPI.host
            components.path = path
            components.queryItems = queryItems
            return components.url
        }
    }
}
