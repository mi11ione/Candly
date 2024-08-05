import Charts
import SharedModels
import SwiftUI

public struct PatternChart: View {
    let pattern: Pattern

    public init(pattern: Pattern) {
        self.pattern = pattern
    }

    public var body: some View {
        ChartConfig.applyCommonConfig(
            Chart {
                ForEach(pattern.candles.sorted(by: { $0.date < $1.date }), id: \.id) { candle in
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
        .frame(width: 350, height: 160)
        .chartYScale(domain: calculateYAxisDomain())
        .id(pattern.id)
    }

    private func calculateYAxisDomain() -> ClosedRange<Double> {
        let prices = pattern.candles.flatMap { [$0.lowPrice, $0.highPrice] }
        guard let min = prices.min(), let max = prices.max() else { return 0 ... 100 }
        let padding = (max - min) * 0.15
        return (min - padding) ... (max + padding)
    }
}
