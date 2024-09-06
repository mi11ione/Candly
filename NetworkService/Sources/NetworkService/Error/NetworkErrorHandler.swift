import Foundation

public protocol NetworkErrorHandler {
    func handle(_ error: Error) -> NetworkError
}

public struct DefaultNetworkErrorHandler: NetworkErrorHandler {
    public init() {}

    public func handle(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        return .requestFailed
    }
}
