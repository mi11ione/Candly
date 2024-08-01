import Foundation
import SharedModels

struct PatternState {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var expandedPatternId: UUID?
}
