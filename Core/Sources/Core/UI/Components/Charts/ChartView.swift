import Charts
import SwiftUI

public struct ChartView: View {
    public let candles: [CandleStick]

    public init(candles: [CandleStick]) {
        self.candles = candles
    }

    public var body: some View {
        ChartConfig.applyCommonConfig(
            Chart {
                ForEach(candles, id: \.time) { candle in
                    candle
                }
            }
        )
        .chartYScale(domain: yAxisDomain)
    }

    private var yAxisDomain: ClosedRange<Double> {
        let prices = candles.flatMap { [$0.lowPrice, $0.highPrice] }
        let min = prices.min() ?? 0
        let max = prices.max() ?? 100
        return ChartConfig.calculateYAxisDomain(minValue: min, maxValue: max)
    }
}
