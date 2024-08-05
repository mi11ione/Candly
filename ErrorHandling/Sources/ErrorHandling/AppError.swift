import Foundation

public enum AppError: Error, Identifiable {
    case network(NetworkError)
    case database(DatabaseError)
    case validation(String)
    case decoding(String)
    case unauthorized
    case notFound
    case serverError
    case unknown

    public var id: String { localizedDescription }

    public var localizedDescription: String {
        switch self {
        case let .network(error):
            error.localizedDescription
        case let .database(error):
            error.localizedDescription
        case let .validation(message):
            "Validation Error: \(message)"
        case let .decoding(message):
            "Decoding Error: \(message)"
        case .unauthorized:
            "Unauthorized Access"
        case .notFound:
            "Resource Not Found"
        case .serverError:
            "Server Error"
        case .unknown:
            "An Unknown Error Occurred"
        }
    }
}
