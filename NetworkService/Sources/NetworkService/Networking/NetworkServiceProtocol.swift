import SharedModels

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> MoexTickersWrapper
    func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> MoexCandlesWrapper
}
