import SharedModels
import SwiftUI

public struct TickerCell: View {
    let ticker: TickerDTO
    let isExpanded: Bool
    let onTap: () -> Void

    public init(ticker: TickerDTO, isExpanded: Bool, onTap: @escaping () -> Void) {
        self.ticker = ticker
        self.isExpanded = isExpanded
        self.onTap = onTap
    }

    public var body: some View {
        DataCell(
            isExpanded: .constant(isExpanded),
            content: {
                HStack {
                    tickerDetails
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
        .onTapGesture(perform: onTap)
    }

    private var tickerDetails: some View {
        VStack(alignment: .leading) {
            Text(ticker.subTitle)
                .font(.title3)
                .bold()
            Text("$\(ticker.title)")
            Spacer()
            Text(String(format: "%.2f", ticker.price))
                .font(.title3)
                .bold()
            Text(priceChangeText)
                .foregroundColor(priceChangeColor)
        }
        .padding(.leading, 4)
    }

    private var priceChangeText: String {
        let change = String(format: "%.2f", abs(ticker.priceChange))
        return ticker.priceChange >= 0 ? "+\(change)" : "-\(change)"
    }

    private var priceChangeColor: Color {
        ticker.priceChange >= 0 ? .green : .red
    }
}
