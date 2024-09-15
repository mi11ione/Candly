import Core
import Models
import SwiftUI

struct TickerChart: View {
    var candles: [Candle]

    var body: some View {
        if candles.isEmpty {
            ProgressView()
                .frame(width: 120, height: 100)
        } else {
            ChartView(candles: candles.map { candle in
                CandleStick(
                    time: candle.formattedTime,
                    openPrice: candle.openPrice,
                    closePrice: candle.closePrice,
                    highPrice: candle.highPrice,
                    lowPrice: candle.lowPrice
                )
            })
        }
    }
}
