import Data
import Domain
import NetworkService
import SharedModels

@MainActor
public protocol Dependency: Sendable {
    func makeFetchPatternsUseCase() -> FetchPatternsUseCaseProtocol
    func makeFetchTickersUseCase() -> FetchTickersUseCaseProtocol
    func makeNetworkService() -> NetworkServiceProtocol
    func makeDataService() -> DataServiceProtocol
    func makeModelContext() -> ModelContextProtocol
}

@MainActor
struct UnimplementedDependency: Dependency {
    func makeFetchPatternsUseCase() -> FetchPatternsUseCaseProtocol { unimplemented() }
    func makeFetchTickersUseCase() -> FetchTickersUseCaseProtocol { unimplemented() }
    func makeNetworkService() -> NetworkServiceProtocol { unimplemented() }
    func makeModelContext() -> ModelContextProtocol { unimplemented() }
    func makeDataService() -> DataServiceProtocol { unimplemented() }

    private func unimplemented() -> Never {
        fatalError("DependencyFactory not implemented")
    }
}
