import Data
import Domain
import Foundation
import NetworkService
import SharedModels
import SwiftData

@Observable
public class AppDependency: Dependency {
    private let modelContainer: ModelContainer
    private let networkService: NetworkServiceProtocol
    private let dataService: DataServiceProtocol
    private let patternRepository: PatternRepositoryProtocol
    private let tickerRepository: TickerRepositoryProtocol
    private let fetchPatternsUseCase: FetchPatternsUseCaseProtocol
    private let fetchTickersUseCase: FetchTickersUseCaseProtocol

    public init(cacheExpirationInterval: TimeInterval = 120) {
        modelContainer = try! ModelContainer(for: Pattern.self, Ticker.self, Candle.self)

        dataService = DataService()

        networkService = NetworkService(
            cacher: NetworkCacher(
                cacheExpirationInterval: cacheExpirationInterval
            )
        )

        let context = ModelContextWrapper(
            context: modelContainer.mainContext
        )

        patternRepository = PatternRepository(
            dataService: dataService,
            context: context
        )

        tickerRepository = TickerRepository(
            networkService: networkService,
            dataService: dataService
        )

        fetchPatternsUseCase = FetchPatternsUseCase(
            repository: patternRepository,
            context: context
        )

        fetchTickersUseCase = FetchTickersUseCase(
            repository: tickerRepository,
            context: context
        )
    }

    public func makeFetchPatternsUseCase() -> FetchPatternsUseCaseProtocol { fetchPatternsUseCase }
    public func makeFetchTickersUseCase() -> FetchTickersUseCaseProtocol { fetchTickersUseCase }
    public func makeNetworkService() -> NetworkServiceProtocol { networkService }
    public func makeDataService() -> DataServiceProtocol { dataService }

    @MainActor
    public func makeModelContext() -> ModelContextProtocol {
        ModelContextWrapper(context: modelContainer.mainContext)
    }
}
