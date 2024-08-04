import SharedModels

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> [Ticker]
    func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle]
}
