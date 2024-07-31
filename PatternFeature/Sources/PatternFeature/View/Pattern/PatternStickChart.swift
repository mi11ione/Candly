import Charts
import SwiftUI

struct PatternStickChart: View {
    let pattern: PatternDTO
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Chart {
            ForEach(pattern.candles) { candle in
                CandleStick(candle: candle)
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
        guard let min = prices.min(), let max = prices.max() else { return 0...100 }
        let padding = (max - min) * 0.15
        return (min - padding)...(max + padding)
    }
}

private struct CandleStick: ChartContent {
    let candle: CandleDTO

    var body: some ChartContent {
        RectangleMark(
            x: .value("Time", candle.date.formatted(date: .omitted, time: .shortened)),
            yStart: .value("Low", candle.lowPrice),
            yEnd: .value("High", candle.highPrice),
            width: .fixed(2)
        )
        .foregroundStyle(Color(.systemGray))
        .clipShape(RoundedRectangle(cornerRadius: 2))

        RectangleMark(
            x: .value("Time", candle.date.formatted(date: .omitted, time: .shortened)),
            yStart: .value("Open", candle.openPrice),
            yEnd: .value("Close", candle.closePrice),
            width: .fixed(10)
        )
        .foregroundStyle(candle.openPrice < candle.closePrice ? .green : .red)
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}
