import Models
import Network

public protocol TickerRepositoryProtocol: Sendable {
    func fetchTickers() async throws -> [Ticker]
    func fetchCandles(for ticker: String, time: Time) async throws -> [Candle]
}

public final class TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let dataService: DataService

    public init(networkService: NetworkServiceProtocol, dataService: DataService = DataService()) {
        self.networkService = networkService
        self.dataService = dataService
    }

    public func fetchTickers() async throws -> [Ticker] {
        let data = try await networkService.getMoexTickers()
        let tickers = try dataService.parseTickers(from: data)
        for ticker in tickers {
            await PersistenceActor.shared.insert(ticker)
        }
        try await PersistenceActor.shared.save()
        return tickers
    }

    public func fetchCandles(for ticker: String, time: Time) async throws -> [Candle] {
        let data = try await networkService.getMoexCandles(ticker: ticker, time: time)
        let candles = try dataService.parseCandles(from: data, ticker: ticker)
        for candle in candles {
            await PersistenceActor.shared.insert(candle)
        }
        try await PersistenceActor.shared.save()
        return candles
    }
}
