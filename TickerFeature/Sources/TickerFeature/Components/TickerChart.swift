import Charts
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
            ChartConfig.applyCommonConfig(
                Chart {
                    ForEach(candles, id: \.id) { candle in
                        CandleStick(
                            time: candle.formattedTime,
                            openPrice: candle.openPrice,
                            closePrice: candle.closePrice,
                            highPrice: candle.highPrice,
                            lowPrice: candle.lowPrice
                        )
                    }
                }
            )
            .chartYScale(domain: yAxisDomain)
        }
    }

    private var yAxisDomain: ClosedRange<Double> {
        let prices = candles.flatMap { [$0.lowPrice, $0.highPrice] }
        let min = prices.min() ?? 0
        let max = prices.max() ?? 100
        return ChartConfig.calculateYAxisDomain(minValue: min, maxValue: max)
    }
}
