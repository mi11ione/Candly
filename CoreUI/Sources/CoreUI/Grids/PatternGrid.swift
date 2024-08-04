import SharedModels
import SwiftUI

public struct PatternGrid: View {
    let patterns: [Pattern]
    let expandedPatternId: UUID?
    let onPatternTapped: (UUID) -> Void

    public init(patterns: [Pattern], expandedPatternId: UUID?, onPatternTapped: @escaping (UUID) -> Void) {
        self.patterns = patterns
        self.expandedPatternId = expandedPatternId
        self.onPatternTapped = onPatternTapped
    }

    public var body: some View {
        GridView(
            items: patterns,
            expandedItemId: expandedPatternId,
            onItemTapped: onPatternTapped
        ) { pattern, isExpanded in
            PatternCell(
                pattern: pattern,
                isExpanded: isExpanded
            )
        }
    }
}
