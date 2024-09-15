import Foundation
import Synchronization

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> Data
    func getMoexCandles(ticker: String, time: Time) async throws -> Data
}

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let cacheManager: CacheManager

    public init(session: URLSession = .shared,
                cacheManager: CacheManager)
    {
        self.session = session
        self.cacheManager = cacheManager
    }

    public func getMoexTickers() async throws -> Data {
        let cacheKey = "moexTickers"
        if let cachedData = await cacheManager.getCachedData(forKey: cacheKey) {
            return cachedData
        }

        guard let url = MoexAPI.Endpoint.allTickers.url(queryItems: []) else {
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

        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: time.queryItems) else {
            throw NetworkError.invalidURL
        }
        let data = try await performRequest(URLRequest(url: url))
        await cacheManager.cacheData(data, forKey: cacheKey)
        return data
    }

    private func performRequest(_ request: URLRequest) async throws -> Data {
        let requestKey = request.url?.absoluteString ?? ""

        if let cachedData = await cacheManager.getCachedData(forKey: requestKey) {
            return cachedData
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            await cacheManager.cacheData(data, forKey: requestKey)
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
