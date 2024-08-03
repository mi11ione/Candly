import CoreRepository
import Foundation
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftData

@MainActor
public final class AppDIContainer: DIContainer, ObservableObject {
    private let dependencyManager = DependencyManager()
    public let modelContainer: ModelContainer

    public init() {
        modelContainer = try! ModelContainer(for: Pattern.self, Candle.self, Ticker.self)
        registerDependencies()
    }

    public func register(_ dependency: some Sendable) {
        Task {
            await dependencyManager.register(dependency)
        }
    }

    public func resolve<T: Sendable>() async -> T {
        await dependencyManager.resolve()
    }

    private func registerDependencies() {
        let modelContext = ModelContextWrapper(modelContainer.mainContext)
        register(modelContext)

        let networkService = NetworkService()
        register(networkService as NetworkServiceProtocol)

        let patternRepository = PatternRepository(modelContext: modelContext)
        register(patternRepository as PatternRepositoryProtocol)

        let tickerRepository = TickerRepository(modelContext: modelContext, networkService: networkService)
        register(tickerRepository as TickerRepositoryProtocol)
    }
}
