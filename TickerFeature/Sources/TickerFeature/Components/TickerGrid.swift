import Core
import Models
import SwiftUI

public struct TickerGrid: View {
    public var tickers: [Ticker]
    public var isLoading: Bool
    public var error: String?
    public var retryAction: () -> Void

    public var body: some View {
        if isLoading {
            ProgressView()
        } else if let error {
            TickerError(message: error, retryAction: retryAction)
        } else {
            GridView(items: tickers) { ticker in
                TickerCell(ticker: ticker)
            }
        }
    }
}
