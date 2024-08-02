import Foundation
import SharedModels

struct PatternState: Equatable {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var expandedPatternId: UUID?
    var isLoading: Bool = false

    static func == (lhs: PatternState, rhs: PatternState) -> Bool {
        lhs.patterns == rhs.patterns &&
            lhs.selectedFilter == rhs.selectedFilter &&
            lhs.expandedPatternId == rhs.expandedPatternId &&
            lhs.isLoading == rhs.isLoading
    }
}
