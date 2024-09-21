import Models
import Network

public protocol FetchTickersUseCaseProtocol: Sendable {
    func execute() async throws -> [Ticker]
    func filterTickers(_ tickers: [Ticker], searchText: String) -> [Ticker]
    func fetchCandles(for ticker: String, time: Time) async throws -> [Candle]
}

public final class FetchTickersUseCase: FetchTickersUseCaseProtocol {
    private let repository: TickerRepositoryProtocol

    public init(repository: TickerRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Ticker] {
        try await repository.fetchTickers()
    }

    public func filterTickers(_ tickers: [Ticker], searchText: String) -> [Ticker] {
        guard !searchText.isEmpty else { return tickers }
        return tickers.filter { ticker in
            ticker.title.lowercased().contains(searchText.lowercased()) ||
                ticker.subTitle.lowercased().contains(searchText.lowercased())
        }
    }

    public func fetchCandles(for ticker: String, time: Time) async throws -> [Candle] {
        try await repository.fetchCandles(for: ticker, time: time)
    }
}
