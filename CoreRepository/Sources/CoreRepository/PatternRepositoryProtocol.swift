import SharedModels

public protocol PatternRepositoryProtocol: Sendable {
    func fetchPatterns() async throws -> [Pattern]
}
