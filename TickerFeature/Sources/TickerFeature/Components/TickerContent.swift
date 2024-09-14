import Models
import SwiftUICore

struct TickerContent: View {
    var ticker: Ticker
    var candles: [Candle]

    var body: some View {
        HStack {
            TickerInfo(ticker: ticker)
            Spacer()
            TickerChart(candles: candles)
        }
        .padding()
        .frame(height: 160)
    }
}
