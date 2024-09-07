import CoreArchitecture
import CoreRepository
import Foundation
import SharedModels

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    private let repository: TickerRepositoryProtocol
    private let context: ModelContextProtocol

    public init(repository: TickerRepositoryProtocol, context: ModelContextProtocol) {
        self.repository = repository
        self.context = context
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedTickers = try await repository.fetchTickers(context: context)
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
