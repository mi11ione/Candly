import Foundation
import NetworkService
import SharedModels

public actor TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let tickerCache: CacheService<String, [Ticker]>
    private let candleCache: CacheService<CandleCacheKey, [Candle]>

    public init(networkService: NetworkServiceProtocol, cacheExpirationInterval: TimeInterval = 120) {
        self.networkService = networkService
        tickerCache = CacheService(expirationInterval: cacheExpirationInterval)
        candleCache = CacheService(expirationInterval: cacheExpirationInterval)
    }

    public func fetchTickers(context: ModelContextProtocol) async throws -> [Ticker] {
        if let cachedTickers = await tickerCache.getValue(forKey: "allTickers") {
            return cachedTickers
        }

        let tickers = try await networkService.getMoexTickers()
        await saveTickers(tickers, context: context)
        await tickerCache.setValue(tickers, forKey: "allTickers")
        return tickers
    }

    public func fetchCandles(for ticker: String, time: ChartTime, context: ModelContextProtocol) async throws -> [Candle] {
        let cacheKey = CandleCacheKey(ticker: ticker, time: time)
        if let cachedCandles = await candleCache.getValue(forKey: cacheKey) {
            return cachedCandles
        }

        let candles = try await networkService.getMoexCandles(ticker: ticker, time: time)
        await saveCandles(candles, for: ticker, context: context)
        await candleCache.setValue(candles, forKey: cacheKey)
        return candles
    }

    private func saveTickers(_ tickers: [Ticker], context: ModelContextProtocol) async {
        await MainActor.run {
            for ticker in tickers {
                context.insert(ticker)
            }
            try? context.save()
        }
    }

    private func saveCandles(_ candles: [Candle], for _: String, context: ModelContextProtocol) async {
        await MainActor.run {
            for candle in candles {
                context.insert(candle)
            }
            try? context.save()
        }
    }
}
