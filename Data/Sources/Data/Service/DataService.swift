import Foundation
import Models

public actor DataService: DataServiceProtocol {
    private let fileManager: FileManager
    private let parser: DataParser

    public init(fileManager: FileManager = .default, parser: DataParser = DataParser()) {
        self.fileManager = fileManager
        self.parser = parser
    }

    public func loadPatterns() async throws -> [Pattern] {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            throw DataServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try parser.parsePatterns(from: data)
    }

    public func parseTickers(from data: Data) async throws -> [Ticker] {
        try parser.parseTickers(from: data)
    }

    public func parseCandles(from data: Data, ticker: String) async throws -> [Candle] {
        try parser.parseCandles(from: data, ticker: ticker)
    }
}

public enum DataServiceError: Error {
    case fileNotFound
}

public protocol DataServiceProtocol: Sendable {
    func loadPatterns() async throws -> [Pattern]
    func parseTickers(from data: Data) async throws -> [Ticker]
    func parseCandles(from data: Data, ticker: String) async throws -> [Candle]
}
