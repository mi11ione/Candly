import Core
import Data
import Foundation
import Models
import Synchronization

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent> {
    private let fetchTickersUseCase: FetchTickersUseCaseProtocol
    private let tickerCount = Atomic<Int>(0)

    public init(fetchTickersUseCase: FetchTickersUseCaseProtocol) {
        self.fetchTickersUseCase = fetchTickersUseCase
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedTickers = try await fetchTickersUseCase.execute()
        updateItems(fetchedTickers)
        tickerCount.wrappingAdd(fetchedTickers.count, ordering: .relaxed)
    }

    public var loadedTickerCount: Int {
        tickerCount.load(ordering: .relaxed)
    }

    override public var filteredItems: [Ticker] {
        fetchTickersUseCase.filterTickers(items, searchText: searchText)
    }

    override public func handle(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            load()
        case let .updateSearchText(text):
            updateSearchText(text)
        }
    }
}
