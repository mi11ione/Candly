import SharedModels

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> MoexTickers
    func getMoexCandles(ticker: String, time: ChartTime) async throws -> MoexCandles
}
