import Core
import Data
import Foundation
import Models

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    @ObservationIgnored private let fetchTickersUseCase: FetchTickersUseCaseProtocol
    private(set) var tickersWithCandles: Set<String> = []

    public init(fetchTickersUseCase: FetchTickersUseCaseProtocol) {
        self.fetchTickersUseCase = fetchTickersUseCase
        super.init()
    }

    @MainActor
    override public func loadItems() async throws {
        let fetchedTickers = try await fetchTickersUseCase.execute()
        updateItems(fetchedTickers)
        
        for ticker in fetchedTickers {
            Task {
                if let candles = try? await fetchTickersUseCase.fetchCandles(for: ticker.title, time: .hour), !candles.isEmpty {
                    tickersWithCandles.insert(ticker.title)
                }
            }
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
            .filter { tickersWithCandles.contains($0.title) }
    }
}
