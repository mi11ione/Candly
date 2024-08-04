import SharedModels
import SwiftUI

public struct PatternGridView: View {
    let patterns: [PatternDTO]
    let expandedPatternId: UUID?
    let onPatternTapped: (UUID) -> Void

    public init(patterns: [PatternDTO], expandedPatternId: UUID?, onPatternTapped: @escaping (UUID) -> Void) {
        self.patterns = patterns
        self.expandedPatternId = expandedPatternId
        self.onPatternTapped = onPatternTapped
    }

    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
            ForEach(patterns) { pattern in
                PatternCell(
                    pattern: pattern,
                    isExpanded: expandedPatternId == pattern.id,
                    onTap: { onPatternTapped(pattern.id) }
                )
                .id(pattern.id)
            }
        }
        .padding()
        .animation(.spring, value: expandedPatternId)
    }
}
