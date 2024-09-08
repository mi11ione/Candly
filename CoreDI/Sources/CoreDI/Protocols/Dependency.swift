import Data
import NetworkService
import SharedModels

@MainActor
public protocol Dependency: Sendable {
    func makePatternRepository() -> PatternRepositoryProtocol
    func makeTickerRepository() -> TickerRepositoryProtocol
    func makeNetworkService() -> NetworkServiceProtocol
    func makeModelContext() -> ModelContextProtocol
    func makeDataService() -> DataServiceProtocol
}

@MainActor
struct UnimplementedDependency: Dependency {
    func makePatternRepository() -> PatternRepositoryProtocol { unimplemented() }
    func makeTickerRepository() -> TickerRepositoryProtocol { unimplemented() }
    func makeNetworkService() -> NetworkServiceProtocol { unimplemented() }
    func makeModelContext() -> ModelContextProtocol { unimplemented() }
    func makeDataService() -> DataServiceProtocol { unimplemented() }

    private func unimplemented() -> Never {
        fatalError("DependencyFactory not implemented")
    }
}
