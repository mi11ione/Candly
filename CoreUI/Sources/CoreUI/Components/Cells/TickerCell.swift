import SharedModels
import SwiftUI

public struct TickerCell: View {
    let ticker: TickerDTO
    @State private var isExpanded = false

    public init(ticker: TickerDTO) {
        self.ticker = ticker
    }

    public var body: some View {
        DataCell(
            isExpanded: $isExpanded,
            content: {
                HStack {
                    tickerDetails
                    Spacer()
                    // chart placeholder
                }
                .padding()
                .frame(width: 350, height: 160)
            },
            footer: {
                EmptyView()
            },
            expandedContent: {
                Text("Detected patterns")
                    .font(.subheadline)
                    .bold()
                    .padding(.vertical, 8)
            }
        )
        .padding(8)
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
