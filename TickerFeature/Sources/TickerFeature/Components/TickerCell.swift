import Core
import Models
import SwiftUICore

public struct TickerCell: View {
    public let ticker: Ticker

    public var body: some View {
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
