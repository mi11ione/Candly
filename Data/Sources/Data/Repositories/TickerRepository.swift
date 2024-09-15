import Models
import Network
import SwiftData

public protocol TickerRepositoryProtocol {
    func fetchTickers() async throws -> [Ticker]
    func fetchCandles(for ticker: String, time: Time) async throws -> [Candle]
}

public actor TickerRepository: TickerRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let dataService: DataService
    private let modelContainer: ModelContainer

    public init(networkService: NetworkServiceProtocol, dataService: DataService = DataService(), modelContainer: ModelContainer) {
        self.networkService = networkService
        self.dataService = dataService
        self.modelContainer = modelContainer
    }

    public func fetchTickers() async throws -> [Ticker] {
        let data = try await networkService.getMoexTickers()
        let tickers = try await dataService.parseTickers(from: data)
        let context = ModelContext(modelContainer)
        for ticker in tickers {
            context.insert(ticker)
        }
        try context.save()
        return tickers
    }

    public func fetchCandles(for ticker: String, time: Time) async throws -> [Candle] {
        let data = try await networkService.getMoexCandles(ticker: ticker, time: time)
        let candles = try await dataService.parseCandles(from: data, ticker: ticker)
        let context = ModelContext(modelContainer)
        for candle in candles {
            context.insert(candle)
        }
        try context.save()
        return candles
    }
}
