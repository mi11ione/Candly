import SharedModels
import SwiftUI

public struct PatternCell: View {
    let pattern: Pattern
    let isExpanded: Bool

    public init(pattern: Pattern, isExpanded: Bool) {
        self.pattern = pattern
        self.isExpanded = isExpanded
    }

    public var body: some View {
        DataCell(
            isExpanded: .constant(isExpanded),
            content: { PatternChart(pattern: pattern) },
            footer: {
                Text(pattern.name)
                    .font(.callout)
                    .bold()
                    .padding(.top, 3)
            },
            expandedContent: {
                Text(pattern.info)
                    .font(.subheadline)
                    .padding(10)
                    .frame(width: 320)
            }
        )
        .id(pattern.id)
    }
}
