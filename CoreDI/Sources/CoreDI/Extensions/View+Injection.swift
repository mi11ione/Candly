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
}
