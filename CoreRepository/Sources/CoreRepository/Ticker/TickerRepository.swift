import NetworkService
import SharedModels

public actor TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func fetchTickers(context: ModelContextProtocol) async throws -> [Ticker] {
        let tickers = try await networkService.getMoexTickers()
        await saveTickers(tickers, context: context)
        return tickers
    }

    public func fetchCandles(for ticker: String, time: ChartTime, context: ModelContextProtocol) async throws -> [Candle] {
        let candles = try await networkService.getMoexCandles(ticker: ticker, time: time)
        await saveCandles(candles, for: ticker, context: context)
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
