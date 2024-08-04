import CoreRepository
import ErrorHandling
import NetworkService
import RepositoryInterfaces

@MainActor
public protocol Dependency: Sendable {
    func makePatternRepository() -> PatternRepositoryProtocol
    func makeTickerRepository() -> TickerRepositoryProtocol
    func makeNetworkService() -> NetworkServiceProtocol
    func makeErrorHandler() -> ErrorHandling
    func makeModelContext() -> ModelContextWrapperProtocol
}

@MainActor
struct UnimplementedDependency: Dependency {
    func makePatternRepository() -> PatternRepositoryProtocol { unimplemented() }
    func makeTickerRepository() -> TickerRepositoryProtocol { unimplemented() }
    func makeNetworkService() -> NetworkServiceProtocol { unimplemented() }
    func makeErrorHandler() -> ErrorHandling { unimplemented() }
    func makeModelContext() -> ModelContextWrapperProtocol { unimplemented() }

    private func unimplemented() -> Never {
        fatalError("DependencyFactory not implemented")
    }
}
