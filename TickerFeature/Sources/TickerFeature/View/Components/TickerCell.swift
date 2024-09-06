import CoreUI
import SharedModels
import SwiftUI

public struct TickerCell: View {
    private let ticker: Ticker
    private let isExpanded: Bool

    public init(ticker: Ticker, isExpanded: Bool) {
        self.ticker = ticker
        self.isExpanded = isExpanded
    }

    public var body: some View {
        DataCell(
            isExpanded: .constant(isExpanded),
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
