import Charts
import SwiftUICore

public enum ChartConfig {
    public static func apply(_ chart: Chart<some ChartContent>) -> some View {
        chart
            .chartXAxis {
                AxisMarks(position: .bottom, values: .automatic(desiredCount: 6)) {
                    AxisGridLine(centered: true)
                    AxisValueLabel(centered: true)
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic(desiredCount: 5))
            }
    }

    public static func yAxisDomain(minValue: Double, maxValue: Double) -> ClosedRange<Double> {
        let padding = (maxValue - minValue) * 0.1
        return (minValue - padding) ... (maxValue + padding)
    }
}
