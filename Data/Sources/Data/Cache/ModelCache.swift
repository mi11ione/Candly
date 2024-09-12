import Foundation
import Models
import Network

public actor ModelCache: CacheProtocol {
    private let tickerCache: CacheService<String, [Ticker]>
    private let candleCache: CacheService<CandleKey, [Candle]>

    public init(cacheExpirationInterval: TimeInterval = 120) {
        tickerCache = CacheService(expirationInterval: cacheExpirationInterval)
        candleCache = CacheService(expirationInterval: cacheExpirationInterval)
    }

    public func getCachedData(forKey key: String) async -> Data? {
        guard let tickers = await tickerCache.getValue(forKey: key) else { return nil }
        return try? JSONEncoder().encode(tickers)
    }

    public func cacheData(_ data: Data, forKey key: String) {
        guard let tickers = try? JSONDecoder().decode([Ticker].self, from: data) else { return }
        Task {
            await tickerCache.setValue(tickers, forKey: key)
        }
    }

    public func getCachedDataArray(forKey key: String, time: Time) async -> Data? {
        let cacheKey = CandleKey(ticker: key, time: time)
        guard let candles = await candleCache.getValue(forKey: cacheKey) else { return nil }
        return try? JSONEncoder().encode(candles)
    }

    public func cacheDataArray(_ data: Data, forKey key: String, time: Time) {
        guard let candles = try? JSONDecoder().decode([Candle].self, from: data) else { return }
        let cacheKey = CandleKey(ticker: key, time: time)
        Task {
            await candleCache.setValue(candles, forKey: cacheKey)
        }
    }

    public func clearCache() {
        Task {
            await tickerCache.clear()
            await candleCache.clear()
        }
    }
}
