import Foundation

public actor CacheManager {
    private let cache: CacheProtocol

    public init(cache: CacheProtocol) {
        self.cache = cache
    }

    public func getCachedTickers() async -> Data? {
        await cache.getCachedData(forKey: "allTickers")
    }

    public func cacheTickers(_ data: Data) async {
        await cache.cacheData(data, forKey: "allTickers")
    }

    public func getCachedCandles(for ticker: String, time: Time) async -> Data? {
        await cache.getCachedDataArray(forKey: ticker, time: time)
    }

    public func cacheCandles(_ data: Data, for ticker: String, time: Time) async {
        await cache.cacheDataArray(data, forKey: ticker, time: time)
    }

    public func clearCache() async {
        await cache.clearCache()
    }
}
