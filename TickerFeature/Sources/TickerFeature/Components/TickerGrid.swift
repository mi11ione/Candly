import Core
import Models
import SwiftUICore

public struct TickerGrid: View {
    public var tickers: [Ticker]

    public var body: some View {
        GridView(items: tickers) { ticker in
            TickerCell(ticker: ticker)
        }
    }
}
