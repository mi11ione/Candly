import SharedModels

public protocol DataServiceProtocol: Sendable {
    func loadPatterns() async throws -> [Pattern]
}
