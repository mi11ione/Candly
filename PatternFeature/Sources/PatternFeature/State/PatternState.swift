import Foundation
import SharedModels

struct PatternState: Equatable {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var isLoading: Bool = false
    var error: String?
    var expandedPatternId: UUID?
    let filterKeys = ["Single", "Double", "Triple", "Complex"]
}
