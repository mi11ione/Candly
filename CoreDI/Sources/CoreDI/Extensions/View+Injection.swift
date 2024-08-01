import SwiftUI

private struct DIContainerEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainer = AppDIContainer()
}

public extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func inject(_ container: DIContainer) -> some View {
        environment(\.diContainer, container)
    }

    func resolveAsync<T: Sendable>() -> T {
        @Environment(\.diContainer) var container

        var result: T?
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            result = await container.resolve()
            semaphore.signal()
        }

        semaphore.wait()
        return result!
    }
}
