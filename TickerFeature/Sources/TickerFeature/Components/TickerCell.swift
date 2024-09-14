import Core
import Models
import SwiftUICore

struct TickerCell: View {
    let ticker: Ticker
    let candles: [Candle]

    var body: some View {
        CellView(
            content: { TickerContent(ticker: ticker, candles: candles) },
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
