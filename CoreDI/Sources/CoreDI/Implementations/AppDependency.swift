import CoreRepository
import Data
import Foundation
import NetworkService
import SharedModels
import SwiftData

@Observable
public class AppDependency: Dependency {
    private let modelContainer: ModelContainer
    private let networkService: NetworkServiceProtocol
    private let patternRepository: PatternRepositoryProtocol
    private let tickerRepository: TickerRepositoryProtocol
    private let dataService: DataServiceProtocol
    private let cacheExpirationInterval: TimeInterval

    public init(cacheExpirationInterval: TimeInterval = 120) {
        modelContainer = try! ModelContainer(for: Pattern.self, Ticker.self, Candle.self)
        networkService = NetworkService()
        dataService = DataService()
        patternRepository = PatternRepository(dataService: dataService, context: ModelContextWrapper(context: modelContainer.mainContext))
        self.cacheExpirationInterval = cacheExpirationInterval
        tickerRepository = TickerRepository(networkService: networkService, cacheExpirationInterval: cacheExpirationInterval)
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
