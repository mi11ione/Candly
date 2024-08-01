import Foundation
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftData

public actor TickerRepository: TickerRepositoryProtocol {
    private let modelContext: ModelContextWrapper
    private let tradingDataService: TradingDataServiceProtocol

    public init(modelContext: ModelContextWrapper, tradingDataService: TradingDataServiceProtocol) {
        self.modelContext = modelContext
        self.tradingDataService = tradingDataService
    }

    public func fetchTickers() async throws -> [TickerDTO] {
        let descriptor = FetchDescriptor<Ticker>()
        let localTickers = try await modelContext.fetch(descriptor) { $0.toDTO() }

        if !localTickers.isEmpty {
            return localTickers
        }

        let networkTickers = try await tradingDataService.getMoexTickers()
        await saveTickers(networkTickers)
        return networkTickers
    }

    public func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO] {
        let descriptor = FetchDescriptor<Candle>(predicate: #Predicate { $0.ticker == ticker })
        let localCandles = try await modelContext.fetch(descriptor) { $0.toDTO() }

        if !localCandles.isEmpty {
            return localCandles
        }

        let networkCandles = try await tradingDataService.getMoexCandles(ticker: ticker, timePeriod: timePeriod)
        await saveCandles(networkCandles, for: ticker)
        return networkCandles
    }

    private func saveTickers(_ tickers: [TickerDTO]) async {
        let tickerModels = tickers.map { Ticker(from: $0) }
        await modelContext.insertMultiple(tickerModels)
        do {
            try await modelContext.save()
        } catch {
            print("Failed to save tickers: \(error)")
        }
    }

    private func saveCandles(_ candles: [CandleDTO], for ticker: String) async {
        let candleModels = candles.map { Candle(from: $0, ticker: ticker) }
        await modelContext.insertMultiple(candleModels)
        do {
            try await modelContext.save()
        } catch {
            print("Failed to save candles: \(error)")
        }
    }
}
