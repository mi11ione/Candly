import Core
import Models
import SwiftUI

public struct TickerGrid: View {
    private let tickers: [Ticker]

    public init(tickers: [Ticker]) {
        self.tickers = tickers
    }

    public var body: some View {
        GridView(items: tickers) { ticker in
            TickerCell(ticker: ticker)
        }
    }
}
