import Data
import Foundation
import SharedModels

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let dataService: DataServiceProtocol
    private let errorHandler: NetworkErrorHandler
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 1.0
    private let maxRetries = 3

    public init(session: URLSession = .shared,
                dataService: DataServiceProtocol,
                errorHandler: NetworkErrorHandler = DefaultNetworkErrorHandler())
    {
        self.session = session
        self.dataService = dataService
        self.errorHandler = errorHandler
    }

    public func getMoexTickers() async throws -> [Ticker] {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }

        let data = try await performRequest(URLRequest(url: url))
        return try await dataService.parseTickers(from: data)
    }

    public func getMoexCandles(ticker: String, time: ChartTime) async throws -> [Candle] {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [time.queryItem]) else {
            throw NetworkError.invalidURL
        }

        let data = try await performRequest(URLRequest(url: url))
        return try await dataService.parseCandles(from: data, ticker: ticker)
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
}
