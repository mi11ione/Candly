import Foundation

public enum DatabaseError: Error, LocalizedError {
    case fetchFailed, saveFailed, deleteFailed, updateFailed, invalidData

    public var errorDescription: String? {
        switch self {
        case .fetchFailed: "Failed to fetch data from the database"
        case .saveFailed: "Failed to save data to the database"
        case .deleteFailed: "Failed to delete data from the database"
        case .updateFailed: "Failed to update data in the database"
        case .invalidData: "Invalid data for database operation"
        }
    }
}
