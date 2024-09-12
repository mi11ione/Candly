import Core
import Models
import SwiftUICore

struct PatternCell: View {
    let pattern: Pattern

    var body: some View {
        CellView(
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
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
            }
        )
    }
}
