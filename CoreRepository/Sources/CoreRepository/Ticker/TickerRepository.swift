import ErrorHandling
import Foundation
import NetworkService
import SharedModels
import SwiftData

public actor TickerRepository: TickerRepositoryProtocol {
    private let modelContext: ModelContextWrapperProtocol
    private let networkService: NetworkServiceProtocol
    private let errorHandler: ErrorHandling
    private let tickerCache: CacheService<String, [Ticker]>
    private let candleCache: CacheService<CandleCacheKey, [Candle]>

    public init(modelContext: ModelContextWrapperProtocol, networkService: NetworkServiceProtocol, errorHandler: ErrorHandling, cacheExpirationInterval: TimeInterval = 120) {
        self.modelContext = modelContext
        self.networkService = networkService
        self.errorHandler = errorHandler
        tickerCache = CacheService(expirationInterval: cacheExpirationInterval)
        candleCache = CacheService(expirationInterval: cacheExpirationInterval)
    }

    public func fetchTickers() async throws -> [Ticker] {
        if let cachedTickers = await tickerCache.getValue(forKey: "allTickers") {
            return cachedTickers
        }

        do {
            let networkTickers = try await networkService.getMoexTickers()
            try await saveTickers(networkTickers)
            await tickerCache.setValue(networkTickers, forKey: "allTickers")
            return networkTickers
        } catch {
            throw errorHandler.handle(error)
        }
    }

    public func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle] {
        let cacheKey = CandleCacheKey(ticker: ticker, timePeriod: timePeriod)
        if let cachedCandles = await candleCache.getValue(forKey: cacheKey) {
            return cachedCandles
        }

        do {
            let descriptor = FetchDescriptor<Candle>(predicate: #Predicate { $0.ticker == ticker })
            let localCandles = try await modelContext.fetch(descriptor) { $0 }

            if !localCandles.isEmpty {
                await candleCache.setValue(localCandles, forKey: cacheKey)
                return localCandles
            }

            let networkCandles = try await networkService.getMoexCandles(ticker: ticker, timePeriod: timePeriod)
            try await saveCandles(networkCandles, for: ticker)
            await candleCache.setValue(networkCandles, forKey: cacheKey)
            return networkCandles
        } catch {
            throw errorHandler.handle(error)
        }
    }

    private func saveTickers(_ tickers: [Ticker]) async throws {
        do {
            await modelContext.insertMultiple(tickers)
            try await modelContext.save()
        } catch {
            throw errorHandler.handle(DatabaseError.saveFailed)
        }
    }

    private func saveCandles(_ candles: [Candle], for _: String) async throws {
        do {
            await modelContext.insertMultiple(candles)
            try await modelContext.save()
        } catch {
            throw errorHandler.handle(DatabaseError.saveFailed)
        }
    }
}
