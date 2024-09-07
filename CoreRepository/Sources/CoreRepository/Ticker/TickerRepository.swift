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

        let moexTickers = try await networkService.getMoexTickers()
        let tickers = await parseTickers(from: moexTickers)
        await saveTickers(tickers, context: context)
        await tickerCache.setValue(tickers, forKey: "allTickers")
        return tickers
    }

    public func fetchCandles(for ticker: String, time: ChartTime, context: ModelContextProtocol) async throws -> [Candle] {
        let cacheKey = CandleCacheKey(ticker: ticker, time: time)
        if let cachedCandles = await candleCache.getValue(forKey: cacheKey) {
            return cachedCandles
        }

        let moexCandles = try await networkService.getMoexCandles(ticker: ticker, time: time)
        let candles = await parseCandles(from: moexCandles, ticker: ticker)
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
