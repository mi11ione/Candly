import SharedModels
import SwiftUI

public struct PatternCell: View {
    let pattern: PatternDTO
    let isExpanded: Bool
    let onTap: () -> Void

    public init(pattern: PatternDTO, isExpanded: Bool, onTap: @escaping () -> Void) {
        self.pattern = pattern
        self.isExpanded = isExpanded
        self.onTap = onTap
    }

    public var body: some View {
        DataCell(
            isExpanded: .constant(isExpanded),
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
        .onTapGesture(perform: onTap)
    }
}
