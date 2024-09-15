import Charts
import Core
import Models
import SwiftUI

struct TickerChart: View {
    var candles: [Candle]

    var body: some View {
        ChartView(candles: candles.map { candle in
            CandleStick(
                time: candle.formattedTime,
                openPrice: candle.openPrice,
                closePrice: candle.closePrice,
                highPrice: candle.highPrice,
                lowPrice: candle.lowPrice
            )
        })
        .chartXAxis(.hidden)
    }
}
