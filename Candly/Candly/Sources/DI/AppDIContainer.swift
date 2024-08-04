import CoreDI
import CoreRepository
import ErrorHandling
import Foundation
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftData

@Observable
public final class AppDIContainer: DIContainer {
    private let dependencyManager = DependencyManager()
    public let modelContainer: ModelContainer

    public init() {
        modelContainer = try! ModelContainer(for: Pattern.self, Candle.self, Ticker.self)
        registerDependencies()
    }

    public func register(_ dependency: some Sendable) {
        dependencyManager.register(dependency)
    }

    public func resolve<T: Sendable>() -> T {
        dependencyManager.resolve()
    }

    private func registerDependencies() {
        let modelContext = ModelContextWrapper(modelContainer.mainContext)
        register(modelContext)

        let errorHandler = DefaultErrorHandler()
        register(errorHandler as ErrorHandling)

        let networkService = NetworkService(errorHandler: errorHandler)
        register(networkService as NetworkServiceProtocol)

        let patternRepository = PatternRepository(modelContext: modelContext, errorHandler: errorHandler)
        register(patternRepository as PatternRepositoryProtocol)

        let tickerRepository = TickerRepository(modelContext: modelContext, networkService: networkService, errorHandler: errorHandler)
        register(tickerRepository as TickerRepositoryProtocol)
    }
}
