import SwiftUI

private struct DependencyKey: EnvironmentKey {
    static let defaultValue: Dependency = UnimplementedDependency()
}

public extension EnvironmentValues {
    var dependencyFactory: Dependency {
        get { self[DependencyKey.self] }
        set { self[DependencyKey.self] = newValue }
    }
}
