import Charts
import SwiftUI

struct PatternStickChart: View {
    let pattern: Pattern
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
        .chartYScale(domain: pattern.yAxisDomain)
    }
}

private struct CandleStick: ChartContent {
    let candle: Candle

    var body: some ChartContent {
        RectangleMark(
            x: .value("Time", candle.formattedTime),
            yStart: .value("Low", candle.lowPrice),
            yEnd: .value("High", candle.highPrice),
            width: .fixed(2)
        )
        .foregroundStyle(Color(.systemGray))
        .clipShape(RoundedRectangle(cornerRadius: 2))

        RectangleMark(
            x: .value("Time", candle.formattedTime),
            yStart: .value("Open", candle.openPrice),
            yEnd: .value("Close", candle.closePrice),
            width: .fixed(10)
        )
        .foregroundStyle(candle.openPrice < candle.closePrice ? .green : .red)
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}
