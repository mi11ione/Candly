import Charts
import SharedModels
import SwiftUI

public struct PatternChart: View {
    let pattern: PatternDTO

    public init(pattern: PatternDTO) {
        self.pattern = pattern
    }

    public var body: some View {
        Chart {
            ForEach(pattern.candles, id: \.id) { candle in
                CandleStick(
                    time: candle.date.formatted(date: .omitted, time: .shortened),
                    openPrice: candle.openPrice,
                    closePrice: candle.closePrice,
                    highPrice: candle.highPrice,
                    lowPrice: candle.lowPrice
                )
            }
        }
        .padding()
        .frame(width: 350, height: 160)
        .chartXAxis {
            AxisMarks(position: .bottom, values: .automatic(desiredCount: 6)) {
                AxisGridLine(centered: true)
                AxisValueLabel(centered: true)
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 5))
        }
        .chartYScale(domain: calculateYAxisDomain())
    }

    private func calculateYAxisDomain() -> ClosedRange<Double> {
        let prices = pattern.candles.flatMap { [$0.lowPrice, $0.highPrice] }
        guard let min = prices.min(), let max = prices.max() else { return 0 ... 100 }
        let padding = (max - min) * 0.15
        return (min - padding) ... (max + padding)
    }
}
