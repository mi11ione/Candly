import SharedModels
import SwiftUI

public struct TickerCell: View {
    let ticker: Ticker
    let isExpanded: Bool

    public init(ticker: Ticker, isExpanded: Bool) {
        self.ticker = ticker
        self.isExpanded = isExpanded
    }

    public var body: some View {
        DataCell(
            isExpanded: .constant(isExpanded),
            content: {
                HStack {
                    TickerDetails(ticker: ticker)
                    Spacer()
                    // chart placeholder
                }
                .padding()
                .frame(width: 350, height: 160)
            },
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
