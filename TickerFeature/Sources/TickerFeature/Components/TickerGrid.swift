import Core
import Models
import SwiftUI

struct TickerGrid: View {
    var tickers: [Ticker]
    var isLoading: Bool
    var error: String?
    var retryAction: () -> Void

    var body: some View {
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
