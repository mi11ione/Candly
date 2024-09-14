import Core
import Models
import SwiftUICore

struct TickerCell: View {
    let ticker: Ticker
    let tickerCandles: TickerModel
    @State private var candles: [Candle] = []

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
        .task {
            candles = await tickerCandles.candles(for: ticker.title)
        }
    }
}
