import Core
import Models
import SwiftUICore

struct PatternChart: View {
    var pattern: Models.Pattern

    var body: some View {
        ChartView(candles: pattern.candles.map { candle in
            CandleStick(
                time: candle.formattedTime,
                openPrice: candle.openPrice,
                closePrice: candle.closePrice,
                highPrice: candle.highPrice,
                lowPrice: candle.lowPrice
            )
        })
        .padding()
        .frame(height: 160)
        .id(pattern.id)
    }
}
