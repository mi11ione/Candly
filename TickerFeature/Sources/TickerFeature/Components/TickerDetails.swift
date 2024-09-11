import Core
import Models
import SwiftUI

public struct TickerDetails: View {
    public var ticker: Ticker

    public var body: some View {
        HStack {
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

            Spacer()

            // chart
        }
        .padding()
        .frame(height: 160)
    }

    private var priceChangeText: String {
        let change = String(format: "%.2f", abs(ticker.priceChange))
        return ticker.priceChange >= 0 ? "+\(change)" : "-\(change)"
    }

    private var priceChangeColor: Color {
        ticker.priceChange >= 0 ? .green : .red
    }
}
