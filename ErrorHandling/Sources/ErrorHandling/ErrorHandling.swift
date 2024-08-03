public protocol ErrorHandling {
    func handle(_ error: Error) -> AppError
}

public struct DefaultErrorHandler: ErrorHandling {
    public init() {}

    public func handle(_ error: Error) -> AppError {
        switch error {
        case let networkError as NetworkError:
            .network(networkError)
        case let databaseError as DatabaseError:
            .database(databaseError)
        case let appError as AppError:
            appError
        default:
            .unknown
        }
    }
}
