import Foundation
import Models

public protocol PatternRepositoryProtocol {
    func fetchPatterns() async throws -> [Pattern]
}

public actor PatternRepository: PatternRepositoryProtocol {
    private let fileManager: FileManager
    private let parser: DataParser

    public init(fileManager: FileManager = .default, parser: DataParser = DataParser()) {
        self.fileManager = fileManager
        self.parser = parser
    }

    public func fetchPatterns() async throws -> [Pattern] {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            throw DataError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        let patterns = try await parser.parsePatterns(from: data)
        for pattern in patterns {
            await PersistenceActor.shared.insert(pattern)
        }
        try await PersistenceActor.shared.save()
        return patterns
    }
}

enum DataError: Error {
    case fileNotFound
}
