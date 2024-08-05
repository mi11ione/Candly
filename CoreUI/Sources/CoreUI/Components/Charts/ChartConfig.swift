import Charts
import SwiftUI

enum ChartConfig {
    static func applyCommonConfig(_ chart: Chart<some ChartContent>) -> some View {
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
}
