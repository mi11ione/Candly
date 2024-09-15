import Foundation

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> Data
    func getMoexCandles(ticker: String, time: Time) async throws -> Data
}

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let cacheManager: CacheManager
    private var lastRequestTime: [String: Date] = [:]
    private let config: NetworkConfig

    public init(
        session: URLSession = .shared,
        cacheManager: CacheManager,
        config: NetworkConfig = NetworkConfig()
    ) {
        self.session = session
        self.cacheManager = cacheManager
        self.config = config
    }

    public func getMoexTickers() async throws -> Data {
        try await fetchData(for: .allTickers, cacheKey: "moexTickers")
    }

    public func getMoexCandles(ticker: String, time: Time) async throws -> Data {
        try await fetchData(for: .candles(ticker), cacheKey: "moexCandles_\(ticker)_\(time.rawValue)", queryItems: time.queryItems)
    }

    private func fetchData(for endpoint: MoexAPI.Endpoint, cacheKey: String, queryItems: [URLQueryItem] = []) async throws -> Data {
        if let cachedData = await cacheManager.getCachedData(forKey: cacheKey) {
            return cachedData
        }

        guard let url = endpoint.url(queryItems: queryItems) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.cachePolicy = config.cachePolicy

        let data = try await performRequest(request)
        await cacheManager.cacheData(data, forKey: cacheKey)
        return data
    }

    private func performRequest(_ request: URLRequest) async throws -> Data {
        let requestKey = request.url?.absoluteString ?? ""

        for attempt in 0 ... config.maxRetries {
            do {
                try await waitForMinInterval(for: requestKey)
                return try await sendRequest(request)
            } catch {
                if attempt == config.maxRetries {
                    throw error
                }
                try await Task.sleep(nanoseconds: UInt64(pow(config.retryDelay, Double(attempt + 1)) * 1_000_000_000))
            }
        }

        throw NetworkError.requestFailed
    }

    private func sendRequest(_ request: URLRequest) async throws -> Data {
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
        case 500 ... 599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }

    private func waitForMinInterval(for requestKey: String) async throws {
        let now = Date()
        if let lastRequest = lastRequestTime[requestKey] {
            let timeSinceLastRequest = now.timeIntervalSince(lastRequest)
            if timeSinceLastRequest < config.minRequestInterval {
                let waitTime = config.minRequestInterval - timeSinceLastRequest
                try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
            }
        }
        lastRequestTime[requestKey] = now
    }
}
