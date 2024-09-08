import CoreUI
import SharedModels
import SwiftUI

public struct TickerGrid: View {
    private let tickers: [Ticker]
    private let expandedTickerId: UUID?
    private let onTickerTapped: (UUID) -> Void

    public init(tickers: [Ticker], expandedTickerId: UUID?, onTickerTapped: @escaping (UUID) -> Void) {
        self.tickers = tickers
        self.expandedTickerId = expandedTickerId
        self.onTickerTapped = onTickerTapped
    }

    public var body: some View {
        GridView(
            items: tickers,
            expandedItemId: expandedTickerId,
            onItemTapped: onTickerTapped
        ) { ticker, isExpanded in
            TickerCell(
                ticker: ticker,
                isExpanded: isExpanded
            )
        }
    }
}