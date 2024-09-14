import Core
import Data
import Foundation
import Models

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    @ObservationIgnored private let fetchTickersUseCase: FetchTickersUseCaseProtocol
    @ObservationIgnored private var loadingTickers: Set<String> = []
    private(set) var candlesCache: [String: [Candle]] = [:]

    public init(fetchTickersUseCase: FetchTickersUseCaseProtocol) {
        self.fetchTickersUseCase = fetchTickersUseCase
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedTickers = try await fetchTickersUseCase.execute()
        await MainActor.run {
            updateItems(fetchedTickers)
            Task {
                await loadCandles()
            }
        }
    }

    private func loadCandles() async {
        let visibleTickers = Array(items.prefix(20))
        for ticker in visibleTickers {
            await fetchCandles(for: ticker.title)
        }
    }

    public func candles(for ticker: String) -> [Candle] {
        if candlesCache[ticker] == nil {
            Task {
                await fetchCandles(for: ticker)
            }
        }
        return candlesCache[ticker] ?? []
    }

    private func fetchCandles(for ticker: String) async {
        guard !loadingTickers.contains(ticker) else { return }

        loadingTickers.insert(ticker)
        do {
            let candles = try await fetchTickersUseCase.fetchCandles(for: ticker, time: .hour)
            let lastTenCandles = Array(candles.suffix(10))
            await MainActor.run {
                candlesCache[ticker] = lastTenCandles
                loadingTickers.remove(ticker)
            }
        } catch {
            loadingTickers.remove(ticker)
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
