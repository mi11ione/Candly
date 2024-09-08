import Foundation
import SharedModels

public actor DataService: DataServiceProtocol {
    private let fileManager: FileManager
    private let decoder: JSONDecoder

    public init(fileManager: FileManager = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.fileManager = fileManager
        self.decoder = decoder
        decoder.dateDecodingStrategy = .iso8601
    }

    public func loadPatterns() async throws -> [Pattern] {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            throw DataServiceError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        return try decoder.decode([Pattern].self, from: data)
    }
}

public enum DataServiceError: Error {
    case fileNotFound
}
