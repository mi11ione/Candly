import Foundation
import Models
import SwiftData

public protocol PatternRepositoryProtocol {
    func fetchPatterns() async throws -> [Pattern]
}

public class PatternRepository: PatternRepositoryProtocol {
    private let dataService: DataService

    public init(dataService: DataService = DataService()) {
        self.dataService = dataService
    }

    public func fetchPatterns() async throws -> [Pattern] {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        let data = try Data(contentsOf: url)
        let patterns = try await dataService.parsePatterns(from: data)

        return patterns
    }
}
