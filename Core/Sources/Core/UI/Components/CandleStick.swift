import Charts
import SwiftUICore

public struct CandleStick: ChartContent {
    private let time: String
    private let openPrice: Double
    private let closePrice: Double
    private let highPrice: Double
    private let lowPrice: Double

    public init(time: String, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double) {
        self.time = time
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
    }

    public var body: some ChartContent {
        RectangleMark(
            x: .value("Time", time),
            yStart: .value("Low", lowPrice),
            yEnd: .value("High", highPrice),
            width: .fixed(2)
        )
        .foregroundStyle(Color("CandleStickColor"))
        .clipShape(RoundedRectangle(cornerRadius: 2))

        RectangleMark(
            x: .value("Time", time),
            yStart: .value("Open", openPrice),
            yEnd: .value("Close", closePrice),
            width: .fixed(10)
        )
        .foregroundStyle(openPrice < closePrice ? .green : .red)
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}
