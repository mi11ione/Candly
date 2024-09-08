import NetworkService
import SharedModels

public protocol TickerRepositoryProtocol: Sendable {
    func fetchTickers(context: ModelContextProtocol) async throws -> [Ticker]
    func fetchCandles(for ticker: String, time: ChartTime, context: ModelContextProtocol) async throws -> [Candle]
}

public actor TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let dataService: DataServiceProtocol

    public init(networkService: NetworkServiceProtocol, dataService: DataServiceProtocol) {
        self.networkService = networkService
        self.dataService = dataService
    }

    public func fetchTickers(context: ModelContextProtocol) async throws -> [Ticker] {
        let data = try await networkService.getMoexTickers()
        let tickers = try await dataService.parseTickers(from: data)
        await saveTickers(tickers, context: context)
        return tickers
    }

    public func fetchCandles(for ticker: String, time: ChartTime, context: ModelContextProtocol) async throws -> [Candle] {
        let data = try await networkService.getMoexCandles(ticker: ticker, time: time)
        let candles = try await dataService.parseCandles(from: data, ticker: ticker)
        await saveCandles(candles, for: ticker, context: context)
        return candles
    }

    @MainActor
    private func saveTickers(_ tickers: [Ticker], context: ModelContextProtocol) async {
        for ticker in tickers {
            context.insert(ticker)
        }
        try? context.save()
    }

    @MainActor
    private func saveCandles(_ candles: [Candle], for _: String, context: ModelContextProtocol) async {
        for candle in candles {
            context.insert(candle)
        }
        try? context.save()
    }
}
