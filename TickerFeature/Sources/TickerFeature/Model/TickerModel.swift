import CoreArchitecture
import Data
import Domain
import Foundation
import SharedModels

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    private let fetchTickersUseCase: FetchTickersUseCaseProtocol

    public init(fetchTickersUseCase: FetchTickersUseCaseProtocol) {
        self.fetchTickersUseCase = fetchTickersUseCase
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedTickers = try await fetchTickersUseCase.execute()
        updateItems(fetchedTickers)
    }

    override public var filteredItems: [Ticker] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    override public func handle(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            load()
        case let .updateSearchText(text):
            updateSearchText(text)
        case let .toggleTickerExpansion(id):
            toggleItemExpansion(id)
        }
    }
}
