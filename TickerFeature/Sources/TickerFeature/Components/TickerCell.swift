import Core
import Models
import SwiftUI

public struct TickerCell: View {
    public let ticker: Ticker

    public var body: some View {
        CellView(
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
