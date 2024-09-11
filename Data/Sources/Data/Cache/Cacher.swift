import Core
import Foundation

public actor Cacher {
    private let tickerCache: CacheService<String, [Ticker]>
    private let candleCache: CacheService<CandleCacheKey, [Candle]>

    public init(cacheExpirationInterval: TimeInterval = 120) {
        tickerCache = CacheService(expirationInterval: cacheExpirationInterval)
        candleCache = CacheService(expirationInterval: cacheExpirationInterval)
    }

    public func getCachedTickers() async -> [Ticker]? {
        await tickerCache.getValue(forKey: "allTickers")
    }

    public func cacheTickers(_ tickers: [Ticker]) async {
        await tickerCache.setValue(tickers, forKey: "allTickers")
    }

    public func getCachedCandles(for ticker: String, time: ChartTime) async -> [Candle]? {
        let key = CandleCacheKey(ticker: ticker, time: time)
        return await candleCache.getValue(forKey: key)
    }

    public func cacheCandles(_ candles: [Candle], for ticker: String, time: ChartTime) async {
        let key = CandleCacheKey(ticker: ticker, time: time)
        await candleCache.setValue(candles, forKey: key)
    }

    public func clearCache() async {
        await tickerCache.clear()
        await candleCache.clear()
    }
}
