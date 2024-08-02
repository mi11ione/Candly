import Foundation
import SharedModels

enum PatternAction: Equatable {
    case loadPatterns
    case patternsLoaded([PatternDTO])
    case filterSelected(String)
    case patternExpanded(UUID)

    static func == (lhs: PatternAction, rhs: PatternAction) -> Bool {
        switch (lhs, rhs) {
        case (.loadPatterns, .loadPatterns):
            true
        case let (.patternsLoaded(lhsPatterns), .patternsLoaded(rhsPatterns)):
            lhsPatterns == rhsPatterns
        case let (.filterSelected(lhsFilter), .filterSelected(rhsFilter)):
            lhsFilter == rhsFilter
        case let (.patternExpanded(lhsId), .patternExpanded(rhsId)):
            lhsId == rhsId
        default:
            false
        }
    }
}
