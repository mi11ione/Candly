import SwiftUI

private struct DIContainerEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainer = AppDIContainer()
}

extension EnvironmentValues {
    public var diContainer: DIContainer {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}

extension View {
    public func inject(_ container: DIContainer) -> some View {
        environment(\.diContainer, container)
    }
}
