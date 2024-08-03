public actor DependencyManager {
    private var dependencies: [String: Any] = [:]

    public func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }

    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("Dependency \(T.self) not registered")
        }
        return dependency
    }
}
