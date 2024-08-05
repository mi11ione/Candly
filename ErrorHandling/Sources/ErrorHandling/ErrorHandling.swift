import Foundation

public protocol ErrorHandling: Sendable {
    func handle(_ error: Error) -> AppError
}

public struct DefaultErrorHandler: ErrorHandling {
    public init() {}

    public func handle(_ error: Error) -> AppError {
        switch error {
        case let error as NetworkError: .network(error)
        case let error as DatabaseError: .database(error)
        case let error as AppError: error
        case let error as DecodingError: .decoding(error.localizedDescription)
        case let error as ValidationError: .validation(error.message)
        default: .unknown
        }
    }
}

public struct ValidationError: Error {
    let message: String
}
