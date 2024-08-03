@MainActor
public protocol DIContainer: AnyObject, Sendable {
    func register<T: Sendable>(_ dependency: T)
    func resolve<T: Sendable>() async -> T
}
