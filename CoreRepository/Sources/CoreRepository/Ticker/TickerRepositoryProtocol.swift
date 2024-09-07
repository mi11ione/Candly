import SharedModels

public protocol TickerRepositoryProtocol: Sendable {
    func fetchTickers(context: ModelContextProtocol) async throws -> [Ticker]
    func fetchCandles(for ticker: String, time: ChartTime, context: ModelContextProtocol) async throws -> [Candle]
}
