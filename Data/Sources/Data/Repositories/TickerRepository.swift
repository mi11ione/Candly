import Models
import Network

public protocol TickerRepositoryProtocol {
    func fetchTickers() async throws -> [Ticker]
    func fetchCandles(for ticker: String, time: Time) async throws -> [Candle]
}

public actor TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let parser: DataParser

    public init(networkService: NetworkServiceProtocol, parser: DataParser = DataParser()) {
        self.networkService = networkService
        self.parser = parser
    }

    public func fetchTickers() async throws -> [Ticker] {
        let data = try await networkService.getMoexTickers()
        let tickers = try await parser.parseTickers(from: data)
        for ticker in tickers {
            await PersistenceActor.shared.insert(ticker)
        }
        try await PersistenceActor.shared.save()
        return tickers
    }

    public func fetchCandles(for ticker: String, time: Time) async throws -> [Candle] {
        let data = try await networkService.getMoexCandles(ticker: ticker, time: time)
        let candles = try await parser.parseCandles(from: data, ticker: ticker)
        for candle in candles {
            await PersistenceActor.shared.insert(candle)
        }
        try await PersistenceActor.shared.save()
        return candles
    }
}
