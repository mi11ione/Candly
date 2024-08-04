import ErrorHandling
import Foundation
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftData

public actor TickerRepository: TickerRepositoryProtocol {
    private let modelContext: ModelContextWrapper
    private let networkService: NetworkServiceProtocol
    private let errorHandler: ErrorHandling

    public init(modelContext: ModelContextWrapper, networkService: NetworkServiceProtocol, errorHandler: ErrorHandling = DefaultErrorHandler()) {
        self.modelContext = modelContext
        self.networkService = networkService
        self.errorHandler = errorHandler
    }

    public func fetchTickers() async throws -> [Ticker] {
        do {
            let networkTickers = try await networkService.getMoexTickers()
            try await saveTickers(networkTickers)
            return networkTickers
        } catch {
            throw errorHandler.handle(error)
        }
    }

    public func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle] {
        do {
            let descriptor = FetchDescriptor<Candle>(predicate: #Predicate { $0.ticker == ticker })
            let localCandles = try await modelContext.fetch(descriptor) { $0 }

            if !localCandles.isEmpty {
                return localCandles
            }

            let networkCandles = try await networkService.getMoexCandles(ticker: ticker, timePeriod: timePeriod)
            try await saveCandles(networkCandles, for: ticker)
            return networkCandles
        } catch {
            throw errorHandler.handle(error)
        }
    }

    private func saveTickers(_ tickers: [Ticker]) async throws {
        do {
            await modelContext.insertMultiple(tickers)
            try await modelContext.save()
        } catch {
            throw errorHandler.handle(DatabaseError.saveFailed)
        }
    }

    private func saveCandles(_ candles: [Candle], for ticker: String) async throws {
        do {
            await modelContext.insertMultiple(candles)
            try await modelContext.save()
        } catch {
            throw errorHandler.handle(DatabaseError.saveFailed)
        }
    }
}
