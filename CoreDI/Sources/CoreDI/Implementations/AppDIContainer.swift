import Foundation

public final class AppDIContainer: DIContainer {
    private let dependencyManager = DependencyManager()

    public init() {}

    public func register<T: Sendable>(_ dependency: T) {
        Task {
            await dependencyManager.register(dependency)
        }
    }

    public func resolve<T: Sendable>() async -> T {
        await dependencyManager.resolve()
    }
}

private actor DependencyManager {
    private var dependencies: [String: Any] = [:]

    func register<T: Sendable>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }

    func resolve<T: Sendable>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("Dependency \(T.self) not registered")
        }
        return dependency
    }
}
