import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL, requestFailed, invalidResponse, decodingError
    case hostNotFound, noInternetConnection, timeout
    case unauthorized, notFound, rateLimitExceeded
    case serverError(Int)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .requestFailed: "Network request failed"
        case .invalidResponse: "Invalid server response"
        case .decodingError: "Error decoding server response"
        case .hostNotFound: "Host not found"
        case .noInternetConnection: "No internet connection"
        case .rateLimitExceeded: "Rate limit exceeded"
        case .timeout: "Request timed out"
        case .unauthorized: "Unauthorized access"
        case .notFound: "Resource not found"
        case let .serverError(code): "Server error: \(code)"
        }
    }
}
