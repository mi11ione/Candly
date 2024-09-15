import Foundation
import Models
import SwiftData

public protocol PatternRepositoryProtocol {
    func fetchPatterns() async throws -> [Pattern]
}

public actor PatternRepository: PatternRepositoryProtocol {
    private let modelContainer: ModelContainer
    private let dataService: DataService

    public init(modelContainer: ModelContainer, dataService: DataService = DataService()) {
        self.modelContainer = modelContainer
        self.dataService = dataService
    }

    public func fetchPatterns() async throws -> [Pattern] {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        let data = try Data(contentsOf: url)
        let patterns = try await dataService.parsePatterns(from: data)

        let context = ModelContext(modelContainer)
        for pattern in patterns {
            context.insert(pattern)
        }
        try context.save()
        return patterns
    }
}
