import Combine
import CoreRepository
import Foundation
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftData

@MainActor
public final class AppDIContainer: DIContainer, ObservableObject {
    private let dependencyManager = DependencyManager()
    @Published public private(set) var modelContainer: ModelContainer?

    public init() {
        Task {
            await setup()
        }
    }

    private func setup() async {
        do {
            modelContainer = try ModelContainer(for: Pattern.self, Candle.self, Ticker.self)
            await registerDependencies()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    public func register(_ dependency: some Sendable) async {
        await dependencyManager.register(dependency)
    }

    public func resolve<T: Sendable>() async -> T {
        await dependencyManager.resolve()
    }

    private func registerDependencies() async {
        guard let modelContainer else { return }
        let modelContext = ModelContextWrapper(modelContainer.mainContext)
        await register(modelContext)
        await register(NetworkService() as NetworkServiceProtocol)
        await register(PatternRepository(modelContext: modelContext) as PatternRepositoryProtocol)
        let networkService: NetworkServiceProtocol = await resolve()
        await register(TickerRepository(modelContext: modelContext, networkService: networkService) as TickerRepositoryProtocol)
    }
}
