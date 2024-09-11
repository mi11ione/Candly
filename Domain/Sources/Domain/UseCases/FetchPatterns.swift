import Core
import Data

public protocol FetchPatternsUseCaseProtocol: Sendable {
    func execute() async throws -> [Pattern]
}

public final class FetchPatternsUseCase: FetchPatternsUseCaseProtocol {
    private let repository: PatternRepositoryProtocol

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Pattern] {
        try await repository.fetchPatterns()
    }
}
