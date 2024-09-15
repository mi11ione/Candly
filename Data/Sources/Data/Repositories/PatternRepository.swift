import Foundation
import Models

public protocol PatternRepositoryProtocol {
    func fetchPatterns() async throws -> [Pattern]
}

public actor PatternRepository: PatternRepositoryProtocol {
    private let fileManager: FileManager
    private let dataService: DataService

    public init(fileManager: FileManager = .default, dataService: DataService = DataService()) {
        self.fileManager = fileManager
        self.dataService = dataService
    }

    public func fetchPatterns() async throws -> [Pattern] {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        let data = try Data(contentsOf: url)

        let patterns = try await dataService.parsePatterns(from: data)
        for pattern in patterns {
            await PersistenceActor.shared.insert(pattern)
        }
        try await PersistenceActor.shared.save()
        return patterns
    }
}
