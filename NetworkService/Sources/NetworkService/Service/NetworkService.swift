import Foundation
import SharedModels

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let errorHandler: NetworkErrorHandler
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 1.0
    private let maxRetries = 3

    public init(session: URLSession = .shared,
                decoder: JSONDecoder = JSONDecoder(),
                errorHandler: NetworkErrorHandler = DefaultNetworkErrorHandler())
    {
        self.session = session
        self.decoder = decoder
        self.errorHandler = errorHandler
    }

    public func getMoexTickers() async throws -> MoexTickers {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }

        let data = try await performRequest(URLRequest(url: url))
        return try decoder.decode(MoexTickers.self, from: data)
    }

    public func getMoexCandles(ticker: String, time: ChartTime) async throws -> MoexCandles {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [time.queryItem]) else {
            throw NetworkError.invalidURL
        }

        let data = try await performRequest(URLRequest(url: url))
        return try decoder.decode(MoexCandles.self, from: data)
    }

    private func performRequest(_ request: URLRequest) async throws -> Data {
        for attempt in 1 ... maxRetries {
            do {
                return try await rateLimitedRequest(request)
            } catch {
                if attempt == maxRetries {
                    throw errorHandler.handle(error)
                }
                try await Task.sleep(for: .seconds(Double(attempt) * 2))
            }
        }
        throw errorHandler.handle(NetworkError.requestFailed)
    }

    private func rateLimitedRequest(_ request: URLRequest) async throws -> Data {
        if let lastRequestTime {
            let timeSinceLastRequest = Date().timeIntervalSince(lastRequestTime)
            if timeSinceLastRequest < minimumRequestInterval {
                try await Task.sleep(for: .seconds(minimumRequestInterval - timeSinceLastRequest))
            }
        }

        lastRequestTime = Date()

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            return data
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 429:
            throw NetworkError.requestFailed
        case 500 ... 599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }

    private func parseMoexTickers(from data: Data) throws -> [Ticker] {
        do {
            let moexTickers = try decoder.decode(MoexTickers.self, from: data)
            let parsedTickers = moexTickers.securities.data.compactMap { tickerData -> Ticker? in
                guard tickerData.count >= 26,
                      case let .string(title) = tickerData[0],
                      case let .string(subTitle) = tickerData[2],
                      case let .double(price) = tickerData[3],
                      case let .double(priceChange) = tickerData[25]
                else { return nil }

                return Ticker(
                    id: UUID(),
                    title: title,
                    subTitle: subTitle,
                    price: price,
                    priceChange: priceChange,
                    currency: "RUB"
                )
            }

            guard !parsedTickers.isEmpty else {
                throw NetworkError.decodingError
            }

            return parsedTickers
        } catch {
            throw errorHandler.handle(error)
        }
    }

    private func parseMoexCandles(from data: Data, ticker: String) throws -> [Candle] {
        do {
            let moexCandles = try decoder.decode(MoexCandles.self, from: data)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let parsedCandles = moexCandles.candles.data.compactMap { candleData -> Candle? in
                guard
                    case let .string(dateString) = candleData[6],
                    let date = dateFormatter.date(from: dateString),
                    case let .double(openPrice) = candleData[0],
                    case let .double(closePrice) = candleData[1],
                    case let .double(highPrice) = candleData[2],
                    case let .double(lowPrice) = candleData[3]
                else { return nil }

                return Candle(
                    id: UUID(),
                    date: date,
                    openPrice: openPrice,
                    closePrice: closePrice,
                    highPrice: highPrice,
                    lowPrice: lowPrice,
                    ticker: ticker
                )
            }

            guard !parsedCandles.isEmpty else {
                throw NetworkError.decodingError
            }

            return parsedCandles
        } catch {
            throw errorHandler.handle(error)
        }
    }
}
