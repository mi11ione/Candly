import Core
import Models
import SwiftUICore

struct TickerCell: View {
    let ticker: Ticker

    var body: some View {
        CellView(
            content: { TickerContent(ticker: ticker) },
            footer: { EmptyView() },
            expandedContent: {
                Text("Detected patterns")
                    .font(.subheadline)
                    .bold()
                    .padding(.vertical, 8)
            }
        )
        .padding(.top, 5)
    }
}
