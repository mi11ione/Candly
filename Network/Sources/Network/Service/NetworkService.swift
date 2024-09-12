import Foundation
import Synchronization

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> Data
    func getMoexCandles(ticker: String, time: Time) async throws -> Data
}

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let cacheManager: CacheManager
    private let lastRequestTime: Mutex<Date?>
    private let minimumRequestInterval: TimeInterval = 1.0
    private let maxRetries = 3

    public init(session: URLSession = .shared,
                cacheManager: CacheManager)
    {
        self.session = session
        self.cacheManager = cacheManager
        self.lastRequestTime = Mutex(nil)
    }

    public func getMoexTickers() async throws -> Data {
        let cacheKey = "moexTickers"
        if let cachedData = await cacheManager.getCachedData(forKey: cacheKey) {
            return cachedData
        }

        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }
        let data = try await performRequest(URLRequest(url: url))
        await cacheManager.cacheData(data, forKey: cacheKey)
        return data
    }

    public func getMoexCandles(ticker: String, time: Time) async throws -> Data {
        let cacheKey = "moexCandles_\(ticker)_\(time.rawValue)"
        if let cachedData = await cacheManager.getCachedData(forKey: cacheKey) {
            return cachedData
        }

        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [time.queryItem]) else {
            throw NetworkError.invalidURL
        }
        let data = try await performRequest(URLRequest(url: url))
        await cacheManager.cacheData(data, forKey: cacheKey)
        return data
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
        let shouldWait = lastRequestTime.withLock { lastRequest in
            if let lastRequest {
                let timeSinceLastRequest = Date().timeIntervalSince(lastRequest)
                if timeSinceLastRequest < minimumRequestInterval {
                    return true
                }
            }
            lastRequest = Date()
            return false
        }

        if shouldWait {
            try await Task.sleep(for: .seconds(minimumRequestInterval))
        }

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
