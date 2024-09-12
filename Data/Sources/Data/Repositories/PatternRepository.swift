import Models

public protocol PatternRepositoryProtocol {
    func fetchPatterns() async throws -> [Pattern]
}

public actor PatternRepository: PatternRepositoryProtocol {
    private let dataService: DataServiceProtocol

    public init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    public func fetchPatterns() async throws -> [Pattern] {
        let patterns = try await dataService.loadPatterns()
        for pattern in patterns {
            await PersistenceActor.shared.insert(pattern)
        }
        try await PersistenceActor.shared.save()
        return patterns
    }
}
