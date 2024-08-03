import ErrorHandling
import Foundation
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftData

public actor TickerRepository: TickerRepositoryProtocol {
    private let modelContext: ModelContextWrapper
    private let networkService: NetworkServiceProtocol

    public init(modelContext: ModelContextWrapper, networkService: NetworkServiceProtocol) {
        self.modelContext = modelContext
        self.networkService = networkService
    }

    public func fetchTickers() async throws -> [TickerDTO] {
        do {
            let networkTickers = try await networkService.getMoexTickers()
            try await saveTickers(networkTickers)
            return networkTickers
        } catch {
            throw DatabaseError.fetchFailed
        }
    }

    public func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO] {
        let descriptor = FetchDescriptor<Candle>(predicate: #Predicate { $0.ticker == ticker })
        let localCandles = try await modelContext.fetch(descriptor) { $0.toDTO() }

        if !localCandles.isEmpty {
            return localCandles
        }

        do {
            let networkCandles = try await networkService.getMoexCandles(ticker: ticker, timePeriod: timePeriod)
            try await saveCandles(networkCandles, for: ticker)
            return networkCandles
        } catch {
            throw DatabaseError.fetchFailed
        }
    }

    private func saveTickers(_ tickers: [TickerDTO]) async throws {
        let tickerModels = tickers.map { Ticker(from: $0) }
        await modelContext.insertMultiple(tickerModels)
        try await modelContext.save()
    }

    private func saveCandles(_ candles: [CandleDTO], for ticker: String) async throws {
        let candleModels = candles.map { Candle(from: $0, ticker: ticker) }
        await modelContext.insertMultiple(candleModels)
        try await modelContext.save()
    }
}
