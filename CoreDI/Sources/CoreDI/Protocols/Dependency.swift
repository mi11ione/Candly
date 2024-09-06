import CoreRepository
import NetworkService

@MainActor
public protocol Dependency: Sendable {
    func makePatternRepository() -> PatternRepositoryProtocol
    func makeTickerRepository() -> TickerRepositoryProtocol
    func makeNetworkService() -> NetworkServiceProtocol
    func makeModelContext() -> ModelContextWrapperProtocol
}

@MainActor
struct UnimplementedDependency: Dependency {
    func makePatternRepository() -> PatternRepositoryProtocol { unimplemented() }
    func makeTickerRepository() -> TickerRepositoryProtocol { unimplemented() }
    func makeNetworkService() -> NetworkServiceProtocol { unimplemented() }
    func makeModelContext() -> ModelContextWrapperProtocol { unimplemented() }

    private func unimplemented() -> Never {
        fatalError("DependencyFactory not implemented")
    }
}
