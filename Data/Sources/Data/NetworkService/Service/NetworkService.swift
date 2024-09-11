import Core
import Foundation

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> Data
    func getMoexCandles(ticker: String, time: ChartTime) async throws -> Data
}

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let cacher: NetworkCacher
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 1.0
    private let maxRetries = 3

    public init(session: URLSession = .shared,
                cacher: NetworkCacher = NetworkCacher())
    {
        self.session = session
        self.cacher = cacher
    }

    public func getMoexTickers() async throws -> Data {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }
        return try await performRequest(URLRequest(url: url))
    }

    public func getMoexCandles(ticker: String, time: ChartTime) async throws -> Data {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [time.queryItem]) else {
            throw NetworkError.invalidURL
        }
        return try await performRequest(URLRequest(url: url))
    }

    private func performRequest(_ request: URLRequest) async throws -> Data {
        for attempt in 1 ... maxRetries {
            do {
                return try await rateLimitedRequest(request)
            } catch {
                if attempt == maxRetries {
                    throw NetworkError.requestFailed
                }
                try await Task.sleep(for: .seconds(Double(attempt) * 2))
            }
        }
        throw NetworkError.requestFailed
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
