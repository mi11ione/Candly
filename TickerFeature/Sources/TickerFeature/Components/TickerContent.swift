import Models
import SwiftUI

struct TickerContent: View {
    @Namespace var namespace
    var ticker: Ticker
    var candles: [Candle]

    var body: some View {
        GeometryReader { geometry in
            NavigationLink {
                Text(ticker.subTitle)
                    .navigationTransition(.zoom(sourceID: ticker.id, in: namespace))
            } label: {
                HStack {
                    TickerInfo(ticker: ticker)
                    Spacer()
                    TickerChart(candles: candles)
                        .frame(width: geometry.size.width / 1.7)
                }
            }
        }
        .padding()
        .frame(height: 160)
    }
}
