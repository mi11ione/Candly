import SharedModels

public protocol PatternRepositoryProtocol: Sendable {
    func fetchPatterns(context: ModelContextProtocol) async throws -> [Pattern]
}

public actor PatternRepository: PatternRepositoryProtocol {
    private let dataService: DataServiceProtocol
    private let context: ModelContextProtocol

    public init(dataService: DataServiceProtocol, context: ModelContextProtocol) {
        self.dataService = dataService
        self.context = context
    }

    @MainActor
    public func fetchPatterns(context: ModelContextProtocol) async throws -> [Pattern] {
        let patterns = try await dataService.loadPatterns()
        for pattern in patterns {
            context.insert(pattern)
        }
        try context.save()
        return patterns
    }
}
