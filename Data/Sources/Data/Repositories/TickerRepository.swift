import Core

public protocol TickerRepositoryProtocol: Sendable {
    func fetchTickers() async throws -> [Ticker]
    func fetchCandles(for ticker: String, time: ChartTime) async throws -> [Candle]
}

public actor TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let dataService: DataServiceProtocol

    public init(networkService: NetworkServiceProtocol, dataService: DataServiceProtocol) {
        self.networkService = networkService
        self.dataService = dataService
    }

    public func fetchTickers() async throws -> [Ticker] {
        let data = try await networkService.getMoexTickers()
        let tickers = try await dataService.parseTickers(from: data)
        for ticker in tickers {
            await PersistenceActor.shared.insert(ticker)
        }
        try await PersistenceActor.shared.save()
        return tickers
    }

    public func fetchCandles(for ticker: String, time: ChartTime) async throws -> [Candle] {
        let data = try await networkService.getMoexCandles(ticker: ticker, time: time)
        let candles = try await dataService.parseCandles(from: data, ticker: ticker)
        for candle in candles {
            await PersistenceActor.shared.insert(candle)
        }
        try await PersistenceActor.shared.save()
        return candles
    }
}
