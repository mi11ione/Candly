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

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
    case unauthorized
    case notFound
    case serverError

    public var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .requestFailed: "Network request failed"
        case .invalidResponse: "Invalid server response"
        case .decodingError: "Error decoding server response"
        case .unauthorized: "Unauthorized access"
        case .notFound: "Resource not found"
        case .serverError: "Server error"
        }
    }
}
