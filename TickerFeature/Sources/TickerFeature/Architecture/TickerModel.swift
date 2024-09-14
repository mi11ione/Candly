import Core
import Data
import Foundation
import Models

@Observable
public final class TickerModel: BaseModel<Ticker, TickerIntent>, @unchecked Sendable {
    @ObservationIgnored
    private let fetchTickersUseCase: FetchTickersUseCaseProtocol
    @ObservationIgnored
    private var candlesCache: [String: [Candle]] = [:]
    @ObservationIgnored
    private var loadingTickers: Set<String> = []
    private let queue = DispatchQueue(label: "com.candly.tickerModel", attributes: .concurrent)

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

    public func candles(for ticker: String) -> [Candle] {
        queue.sync {
            if candlesCache[ticker] == nil, !loadingTickers.contains(ticker) {
                loadingTickers.insert(ticker)
                Task {
                    await fetchCandles(for: ticker)
                }
            }
            return candlesCache[ticker] ?? []
        }
    }

    private func fetchCandles(for ticker: String) async {
        do {
            let candles = try await fetchTickersUseCase.fetchCandles(for: ticker, time: .hour)
            let lastTenCandles = Array(candles.suffix(10))
            await updateCacheAndLoadingState(ticker: ticker, candles: lastTenCandles)
        } catch {
            print("Error fetching candles for \(ticker): \(error)")
            await updateCacheAndLoadingState(ticker: ticker, candles: nil)
        }
    }

    @Sendable
    private func updateCacheAndLoadingState(ticker: String, candles: [Candle]?) async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) {
                if let candles {
                    self.candlesCache[ticker] = candles
                }
                self.loadingTickers.remove(ticker)
                continuation.resume()
            }
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
}
