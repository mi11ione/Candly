import CoreRepository
import ErrorHandling
import Foundation
import NetworkService
import SharedModels
import SwiftData

@Observable
public class AppDependency: Dependency {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContextWrapperProtocol
    private let errorHandler: ErrorHandling
    private let networkService: NetworkServiceProtocol
    private let patternRepository: PatternRepositoryProtocol
    private let tickerRepository: TickerRepositoryProtocol
    private let cacheExpirationInterval: TimeInterval

    public init(cacheExpirationInterval: TimeInterval = 120) {
        modelContainer = try! ModelContainer(for: Pattern.self, Ticker.self, Candle.self)
        modelContext = ModelContextWrapper(modelContainer.mainContext)
        errorHandler = DefaultErrorHandler()
        networkService = NetworkService(errorHandler: errorHandler)
        patternRepository = PatternRepository(modelContext: modelContext, errorHandler: errorHandler)
        self.cacheExpirationInterval = cacheExpirationInterval
        tickerRepository = TickerRepository(modelContext: modelContext, networkService: networkService, errorHandler: errorHandler, cacheExpirationInterval: cacheExpirationInterval)
    }

    public func makePatternRepository() -> PatternRepositoryProtocol { patternRepository }
    public func makeTickerRepository() -> TickerRepositoryProtocol { tickerRepository }
    public func makeNetworkService() -> NetworkServiceProtocol { networkService }
    public func makeErrorHandler() -> ErrorHandling { errorHandler }
    public func makeModelContext() -> ModelContextWrapperProtocol { modelContext }
}
