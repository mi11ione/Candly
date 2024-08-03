import Foundation
import SharedModels

struct PatternState: Equatable {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var isLoading: Bool = false
    var expandedPatternId: UUID?
    let filterKeys = ["Single", "Double", "Triple", "Complex"]
}
