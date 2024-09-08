import Data
import SharedModels

public protocol FetchPatternsUseCaseProtocol {
    func execute() async throws -> [Pattern]
}

public class FetchPatternsUseCase: FetchPatternsUseCaseProtocol {
    private let repository: PatternRepositoryProtocol
    private let context: ModelContextProtocol

    public init(repository: PatternRepositoryProtocol, context: ModelContextProtocol) {
        self.repository = repository
        self.context = context
    }

    public func execute() async throws -> [Pattern] {
        try await repository.fetchPatterns(context: context)
    }
}
