import Core
import Data
import Foundation
import Models

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    @ObservationIgnored private let fetchTickersUseCase: FetchTickersUseCaseProtocol
    private var candlesCache: [String: [Candle]] = [:]

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

    @MainActor
    public func candles(for ticker: String) -> [Candle] {
        if candlesCache[ticker] == nil {
            Task {
                await fetchCandles(for: ticker)
            }
        }
        return candlesCache[ticker] ?? []
    }

    @MainActor
    private func fetchCandles(for ticker: String) async {
        do {
            let candles = try await fetchTickersUseCase.fetchCandles(for: ticker, time: .hour)
            candlesCache[ticker] = Array(candles.suffix(10))
        } catch {}
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
