public enum AppError: Error {
    case network(NetworkError)
    case database(DatabaseError)
    case validation(String)
    case unknown
}
