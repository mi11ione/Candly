actor DependencyManager {
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
