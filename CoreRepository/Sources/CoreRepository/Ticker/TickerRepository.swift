import Foundation
import NetworkService
import SharedModels
import SwiftData

public actor TickerRepository: TickerRepositoryProtocol {
    private let modelContext: ModelContextWrapperProtocol
    private let networkService: NetworkServiceProtocol
    private let tickerCache: CacheService<String, [Ticker]>
    private let candleCache: CacheService<CandleCacheKey, [Candle]>

    public init(modelContext: ModelContextWrapperProtocol, networkService: NetworkServiceProtocol, cacheExpirationInterval: TimeInterval = 120) {
        self.modelContext = modelContext
        self.networkService = networkService
        tickerCache = CacheService(expirationInterval: cacheExpirationInterval)
        candleCache = CacheService(expirationInterval: cacheExpirationInterval)
    }

    public func fetchTickers() async throws -> [Ticker] {
        if let cachedTickers = await tickerCache.getValue(forKey: "allTickers") {
            return cachedTickers
        }

        let moexTickersWrapper = try await networkService.getMoexTickers()
        let tickers = await parseTickers(from: moexTickersWrapper.moexTickers)
        try await saveTickers(tickers)
        await tickerCache.setValue(tickers, forKey: "allTickers")
        return tickers
    }

    public func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle] {
        let cacheKey = CandleCacheKey(ticker: ticker, timePeriod: timePeriod)
        if let cachedCandles = await candleCache.getValue(forKey: cacheKey) {
            return cachedCandles
        }

        let descriptor = FetchDescriptor<Candle>(predicate: #Predicate { $0.ticker == ticker })
        let localCandles = try await modelContext.fetch(descriptor) { $0 }

        if !localCandles.isEmpty {
            await candleCache.setValue(localCandles, forKey: cacheKey)
            return localCandles
        }

        let moexCandlesWrapper = try await networkService.getMoexCandles(ticker: ticker, timePeriod: timePeriod)
        let candles = await parseCandles(from: moexCandlesWrapper.moexCandles, ticker: ticker)
        try await saveCandles(candles, for: ticker)
        await candleCache.setValue(candles, forKey: cacheKey)
        return candles
    }

    private func saveTickers(_ tickers: [Ticker]) async throws {
        await modelContext.insertMultiple(tickers)
        try await modelContext.save()
    }

    private func saveCandles(_ candles: [Candle], for _: String) async throws {
        await modelContext.insertMultiple(candles)
        try await modelContext.save()
    }

    @MainActor
    private func parseTickers(from moexTickers: MoexTickers) -> [Ticker] {
        moexTickers.securities.data.compactMap { tickerData -> Ticker? in
            guard tickerData.count >= 26,
                  case let .string(title) = tickerData[0],
                  case let .string(subTitle) = tickerData[2],
                  case let .double(price) = tickerData[3],
                  case let .double(priceChange) = tickerData[25]
            else { return nil }

            return Ticker(
                id: UUID(),
                title: title,
                subTitle: subTitle,
                price: price,
                priceChange: priceChange,
                currency: "RUB"
            )
        }
    }

    @MainActor
    private func parseCandles(from moexCandles: MoexCandles, ticker: String) -> [Candle] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return moexCandles.candles.data.compactMap { candleData -> Candle? in
            guard
                candleData.count >= 7,
                case let .string(dateString) = candleData[6],
                let date = dateFormatter.date(from: dateString),
                case let .double(openPrice) = candleData[0],
                case let .double(closePrice) = candleData[1],
                case let .double(highPrice) = candleData[2],
                case let .double(lowPrice) = candleData[3]
            else { return nil }

            return Candle(
                id: UUID(),
                date: date,
                openPrice: openPrice,
                closePrice: closePrice,
                highPrice: highPrice,
                lowPrice: lowPrice,
                ticker: ticker
            )
        }
    }
}
