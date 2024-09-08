import Foundation
import SharedModels

public protocol DataServiceProtocol: Sendable {
    func loadPatterns() async throws -> [Pattern]
    func parseTickers(from data: Data) async throws -> [Ticker]
    func parseCandles(from data: Data, ticker: String) async throws -> [Candle]
}
