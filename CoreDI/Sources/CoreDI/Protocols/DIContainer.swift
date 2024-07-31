import Foundation

public protocol DIContainer: Sendable {
    func register<T: Sendable>(_ dependency: T)
    func resolve<T: Sendable>() async -> T
}
