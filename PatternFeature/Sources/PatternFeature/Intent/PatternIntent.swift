import Foundation

enum PatternIntent: Equatable {
    case loadPatterns
    case filterSelected(String)
    case togglePatternExpansion(UUID)
}
