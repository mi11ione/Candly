import Charts
import Core
import Models
import SwiftUI

public struct PatternChart: View {
    private let pattern: Pattern

    public init(pattern: Pattern) {
        self.pattern = pattern
    }

    public var body: some View {
        ChartConfig.applyCommonConfig(
            Chart {
                ForEach(pattern.candles, id: \.id) { candle in
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
        .padding()
        .frame(height: 160)
        .chartYScale(domain: yAxisDomain)
        .id(pattern.id)
    }

    private var yAxisDomain: ClosedRange<Double> {
        let prices = pattern.candles.flatMap { [$0.lowPrice, $0.highPrice] }
        let min = prices.min() ?? 0
        let max = prices.max() ?? 100
        return ChartConfig.calculateYAxisDomain(minValue: min, maxValue: max)
    }
}
