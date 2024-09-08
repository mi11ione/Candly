import Data
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

    public init(cacheExpirationInterval: TimeInterval = 120) {
        modelContainer = try! ModelContainer(for: Pattern.self, Ticker.self, Candle.self)

        dataService = DataService()

        networkService = NetworkService(
            cacher: NetworkCacher(
                cacheExpirationInterval: cacheExpirationInterval
            )
        )

        patternRepository = PatternRepository(
            dataService: dataService,
            context: ModelContextWrapper(context: modelContainer.mainContext)
        )

        tickerRepository = TickerRepository(
            networkService: networkService,
            dataService: dataService
        )
    }

    public func makePatternRepository() -> PatternRepositoryProtocol { patternRepository }
    public func makeTickerRepository() -> TickerRepositoryProtocol { tickerRepository }
    public func makeNetworkService() -> NetworkServiceProtocol { networkService }
    public func makeDataService() -> DataServiceProtocol { dataService }

    @MainActor
    public func makeModelContext() -> ModelContextProtocol {
        ModelContextWrapper(context: modelContainer.mainContext)
    }
}
