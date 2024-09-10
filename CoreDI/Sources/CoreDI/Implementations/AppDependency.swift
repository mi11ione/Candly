import Data
import Domain
import Foundation
import NetworkService
import SharedModels
import SwiftData

@Observable
public class AppDependency: Dependency {
    private let networkService: NetworkServiceProtocol
    private let dataService: DataServiceProtocol
    private let patternRepository: PatternRepositoryProtocol
    private let tickerRepository: TickerRepositoryProtocol
    private let fetchPatternsUseCase: FetchPatternsUseCaseProtocol
    private let fetchTickersUseCase: FetchTickersUseCaseProtocol

    public init(cacheExpirationInterval: TimeInterval = 120) {
        dataService = DataService()

        networkService = NetworkService(
            cacher: NetworkCacher(
                cacheExpirationInterval: cacheExpirationInterval
            )
        )

        patternRepository = PatternRepository(
            dataService: dataService
        )

        tickerRepository = TickerRepository(
            networkService: networkService,
            dataService: dataService
        )

        fetchPatternsUseCase = FetchPatternsUseCase(
            repository: patternRepository
        )

        fetchTickersUseCase = FetchTickersUseCase(
            repository: tickerRepository
        )
    }

    public func makeFetchPatternsUseCase() -> FetchPatternsUseCaseProtocol { fetchPatternsUseCase }
    public func makeFetchTickersUseCase() -> FetchTickersUseCaseProtocol { fetchTickersUseCase }
    public func makeNetworkService() -> NetworkServiceProtocol { networkService }
    public func makeDataService() -> DataServiceProtocol { dataService }

    public func makeModelContext() -> ModelContextProtocol {
        PersistenceActor.shared
    }
}
