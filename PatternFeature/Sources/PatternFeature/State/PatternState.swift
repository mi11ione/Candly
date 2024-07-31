import Foundation

struct PatternState {
    var patterns: [Pattern] = []
    var selectedFilter: String = ""
    var expandedPatternId: UUID?
}
