import CoreRepository
import ErrorHandling
import NetworkService
import SwiftData

@Observable
public class AppDependency: Dependency {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContextWrapperProtocol
    private let errorHandler: ErrorHandling
    private let networkService: NetworkServiceProtocol
    private let patternRepository: PatternRepositoryProtocol
    private let tickerRepository: TickerRepositoryProtocol

    public init() {
        modelContainer = try! ModelContainer()
        modelContext = ModelContextWrapper(modelContainer.mainContext)
        errorHandler = DefaultErrorHandler()
        networkService = NetworkService(errorHandler: errorHandler)
        patternRepository = PatternRepository(modelContext: modelContext, errorHandler: errorHandler)
        tickerRepository = TickerRepository(modelContext: modelContext, networkService: networkService, errorHandler: errorHandler)
    }

    public func makePatternRepository() -> PatternRepositoryProtocol { patternRepository }

    public func makeTickerRepository() -> TickerRepositoryProtocol { tickerRepository }

    public func makeNetworkService() -> NetworkServiceProtocol { networkService }

    public func makeErrorHandler() -> ErrorHandling { errorHandler }

    public func makeModelContext() -> ModelContextWrapperProtocol { modelContext }
}
