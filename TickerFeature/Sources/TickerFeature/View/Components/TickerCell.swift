import CoreUI
import SharedModels
import SwiftUI

public struct TickerCell: View {
    private let ticker: Ticker

    public init(ticker: Ticker) {
        self.ticker = ticker
    }

    public var body: some View {
        DataCell(
            content: { TickerDetails(ticker: ticker) },
            footer: { EmptyView() },
            expandedContent: {
                Text("Detected patterns")
                    .font(.subheadline)
                    .bold()
                    .padding(.vertical, 8)
            }
        )
        .padding(.top, 5)
    }
}
