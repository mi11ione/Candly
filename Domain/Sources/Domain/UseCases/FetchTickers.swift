import Data
import SharedModels

public protocol FetchTickersUseCaseProtocol {
    func execute() async throws -> [Ticker]
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
}
