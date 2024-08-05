import ErrorHandling
import Foundation
import SharedModels

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let errorHandler: ErrorHandling
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 1.0
    private let maxRetries = 3

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), errorHandler: ErrorHandling = DefaultErrorHandler()) {
        self.session = session
        self.decoder = decoder
        self.errorHandler = errorHandler
    }

    public func getMoexTickers() async throws -> [Ticker] {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw errorHandler.handle(NetworkError.invalidURL)
        }

        let data = try await performRequest(URLRequest(url: url))
        return try parseMoexTickers(from: data)
    }

    public func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle] {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [timePeriod.queryItem]) else {
            throw errorHandler.handle(NetworkError.invalidURL)
        }

        let data = try await performRequest(URLRequest(url: url))
        return try parseMoexCandles(from: data, ticker: ticker)
    }

    private func performRequest(_ request: URLRequest) async throws -> Data {
        for attempt in 1 ... maxRetries {
            do {
                return try await rateLimitedRequest(request, attempt: attempt)
            } catch {
                if attempt == maxRetries {
                    throw error
                }
                try await Task.sleep(for: .seconds(Double(attempt) * 2))
            }
        }
        throw NetworkError.requestFailed
    }

    private func rateLimitedRequest(_ request: URLRequest, attempt _: Int) async throws -> Data {
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
            throw NetworkError.rateLimitExceeded
        case 500 ... 599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.invalidResponse
        }
    }

    private func parseMoexTickers(from data: Data) throws -> [Ticker] {
        let moexTickers = try decoder.decode(MoexTickers.self, from: data)
        let parsedTickers = moexTickers.securities.data.compactMap { tickerData -> Ticker? in
            guard tickerData.count >= 26 else {
                print("Ticker data has insufficient elements: \(tickerData)")
                return nil
            }

            guard case let .string(title) = tickerData[0],
                  case let .string(subTitle) = tickerData[2],
                  case let .double(price) = tickerData[3],
                  case let .double(priceChange) = tickerData[25]
            else {
                print("Invalid ticker data types: \(tickerData)")
                return nil
            }

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
            throw errorHandler.handle(NetworkError.decodingError)
        }

        print("Parsed \(parsedTickers.count) tickers")
        return parsedTickers
    }

    private func parseMoexCandles(from data: Data, ticker: String) throws -> [Candle] {
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
            throw errorHandler.handle(NetworkError.decodingError)
        }

        return parsedCandles
    }
}
