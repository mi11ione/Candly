import CoreUI
import SharedModels
import SwiftUI

public struct PatternCell: View {
    private let pattern: Pattern

    public init(pattern: Pattern) {
        self.pattern = pattern
    }

    public var body: some View {
        DataCell(
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
            }
        )
    }
}
