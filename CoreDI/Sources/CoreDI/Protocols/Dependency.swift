import CoreRepository
import SharedModels
import NetworkService

@MainActor
public protocol Dependency: Sendable {
    func makePatternRepository() -> PatternRepositoryProtocol
    func makeTickerRepository() -> TickerRepositoryProtocol
    func makeNetworkService() -> NetworkServiceProtocol
    func makeModelContext() -> ModelContextProtocol
}

@MainActor
struct UnimplementedDependency: Dependency {
    func makePatternRepository() -> PatternRepositoryProtocol { unimplemented() }
    func makeTickerRepository() -> TickerRepositoryProtocol { unimplemented() }
    func makeNetworkService() -> NetworkServiceProtocol { unimplemented() }
    func makeModelContext() -> ModelContextProtocol { unimplemented() }

    private func unimplemented() -> Never {
        fatalError("DependencyFactory not implemented")
    }
}
