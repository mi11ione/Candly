import CoreRepository
import ErrorHandling
import Foundation
import NetworkService
import SwiftData

@Observable
public class AppDependency: Dependency {
    private let modelContext: ModelContextWrapperProtocol
    private let errorHandler: ErrorHandling
    private let networkService: NetworkServiceProtocol
    private let patternRepository: PatternRepositoryProtocol
    private let tickerRepository: TickerRepositoryProtocol

    public init(cacheExpirationInterval: TimeInterval = 120) {
        do {
            let modelContainer = try ModelContainer()
            modelContext = ModelContextWrapper(modelContainer.mainContext)
            errorHandler = DefaultErrorHandler()
            networkService = NetworkService(errorHandler: errorHandler)
            patternRepository = PatternRepository(modelContext: modelContext, errorHandler: errorHandler)
            tickerRepository = TickerRepository(modelContext: modelContext, networkService: networkService, errorHandler: errorHandler, cacheExpirationInterval: cacheExpirationInterval)
        } catch {
            fatalError("Failed to initialize AppDependency: \(error)")
        }
    }

    public func makePatternRepository() -> PatternRepositoryProtocol { patternRepository }
    public func makeTickerRepository() -> TickerRepositoryProtocol { tickerRepository }
    public func makeNetworkService() -> NetworkServiceProtocol { networkService }
    public func makeErrorHandler() -> ErrorHandling { errorHandler }
    public func makeModelContext() -> ModelContextWrapperProtocol { modelContext }
}
