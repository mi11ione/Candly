import Data
import SharedModels

public protocol FetchTickersUseCaseProtocol {
    func execute() async throws -> [Ticker]
    func filterTickers(_ tickers: [Ticker], searchText: String) -> [Ticker]
}

public class FetchTickersUseCase: FetchTickersUseCaseProtocol {
    private let repository: TickerRepositoryProtocol
    private let context: ModelContextProtocol

    public init(repository: TickerRepositoryProtocol, context: ModelContextProtocol) {
        self.repository = repository
        self.context = context
    }

    public func execute() async throws -> [Ticker] {
        try await repository.fetchTickers(context: context)
    }

    public func filterTickers(_ tickers: [Ticker], searchText: String) -> [Ticker] {
        guard !searchText.isEmpty else { return tickers }
        return tickers.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
