import SharedModels
import SwiftUI

public struct TickerGrid: View {
    let tickers: [TickerDTO]
    let expandedTickerId: UUID?
    let onTickerTapped: (UUID) -> Void

    public init(tickers: [TickerDTO], expandedTickerId: UUID?, onTickerTapped: @escaping (UUID) -> Void) {
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
