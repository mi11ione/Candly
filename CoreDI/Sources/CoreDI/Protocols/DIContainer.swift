public protocol DIContainer: AnyObject, Sendable {
    func register<T: Sendable>(_ dependency: T) async
    func resolve<T: Sendable>() async -> T
}
