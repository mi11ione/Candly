import Foundation
import SharedModels

public protocol TickerRepositoryProtocol: Sendable {
    func fetchTickers() async throws -> [TickerDTO]
    func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO]
}
