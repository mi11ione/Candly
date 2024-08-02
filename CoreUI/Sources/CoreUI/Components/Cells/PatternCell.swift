import SharedModels
import SwiftUI

public struct PatternCell: View {
    let pattern: PatternDTO
    @State private var isExpanded = false

    public init(pattern: PatternDTO) {
        self.pattern = pattern
    }

    public var body: some View {
        DataCell(
            isExpanded: $isExpanded,
            content: {
                PatternChart(pattern: pattern)
            },
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
    }
}
