import Foundation
import SharedModels

struct PatternState: Equatable {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var isLoading: Bool = false
    let filterKeys = ["Single", "Double", "Triple", "Complex"]

    static func == (lhs: PatternState, rhs: PatternState) -> Bool {
        lhs.patterns == rhs.patterns &&
            lhs.selectedFilter == rhs.selectedFilter &&
            lhs.isLoading == rhs.isLoading
    }
}
