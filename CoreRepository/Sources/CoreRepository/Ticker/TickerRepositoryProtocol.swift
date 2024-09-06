import SharedModels

public protocol TickerRepositoryProtocol: Sendable {
    func fetchTickers() async throws -> [Ticker]
    func fetchCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle]
}
