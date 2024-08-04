import SharedModels
import SwiftUI

public struct TickerGridView: View {
    let tickers: [TickerDTO]
    let expandedTickerId: UUID?
    let onTickerTapped: (UUID) -> Void

    public init(tickers: [TickerDTO], expandedTickerId: UUID?, onTickerTapped: @escaping (UUID) -> Void) {
        self.tickers = tickers
        self.expandedTickerId = expandedTickerId
        self.onTickerTapped = onTickerTapped
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                ForEach(tickers) { ticker in
                    TickerCell(
                        ticker: ticker,
                        isExpanded: expandedTickerId == ticker.id,
                        onTap: { onTickerTapped(ticker.id) }
                    )
                }
            }
            .padding()
            .animation(.spring, value: expandedTickerId)
        }
    }
}
