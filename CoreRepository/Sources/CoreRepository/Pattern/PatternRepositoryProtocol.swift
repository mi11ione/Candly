import SharedModels

public protocol PatternRepositoryProtocol: Sendable {
    func fetchPatterns(context: ModelContextProtocol) async throws -> [Pattern]
}
