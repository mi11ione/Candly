import Models

public protocol FetchTickersUseCaseProtocol {
    func execute() async throws -> [Ticker]
    func filterTickers(_ tickers: [Ticker], searchText: String) -> [Ticker]
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
}
