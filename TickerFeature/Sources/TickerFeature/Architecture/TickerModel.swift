import Core
import Data
import Foundation
import Models

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    @ObservationIgnored private let fetchTickersUseCase: FetchTickersUseCaseProtocol

    public init(fetchTickersUseCase: FetchTickersUseCaseProtocol) {
        self.fetchTickersUseCase = fetchTickersUseCase
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedTickers = try await fetchTickersUseCase.execute()
        await MainActor.run {
            updateItems(fetchedTickers)
        }
    }

    public func candles(for ticker: String) async -> [Candle] {
        do {
            let candles = try await fetchTickersUseCase.fetchCandles(for: ticker, time: .hour)
            return Array(candles.suffix(10))
        } catch {
            return []
        }
    }

    override public func handle(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            load()
        case let .updateSearchText(text):
            updateSearchText(text)
        }
    }

    override public var filteredItems: [Ticker] {
        fetchTickersUseCase.filterTickers(items, searchText: searchText)
    }
}
