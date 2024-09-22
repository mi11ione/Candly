import Models
import SwiftUICore

struct TickerContent: View {
    var ticker: Ticker
    var candles: [Candle]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                TickerInfo(ticker: ticker)
                Spacer()
                TickerChart(candles: candles)
                    .frame(width: geometry.size.width / 1.7)
            }
        }
        .padding()
        .frame(height: 160)
    }
}
