import Foundation

enum PatternIntent: Equatable {
    case loadPatterns
    case filterSelected(String)
    case patternExpanded(UUID)
}
