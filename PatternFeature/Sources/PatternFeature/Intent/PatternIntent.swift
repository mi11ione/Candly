import Foundation

enum PatternIntent: Equatable {
    case loadPatterns
    case selectFilter(String)
    case toggleExpandPattern(UUID)
}
