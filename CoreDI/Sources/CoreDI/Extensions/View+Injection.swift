import SwiftUI

private final class UnimplementedDIContainer: DIContainer {
    func register(_: some Sendable) {
        fatalError("DIContainer not implemented")
    }

    func resolve<T: Sendable>() -> T {
        fatalError("DIContainer not implemented")
    }
}

private struct DIContainerEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainer = UnimplementedDIContainer()
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
}
