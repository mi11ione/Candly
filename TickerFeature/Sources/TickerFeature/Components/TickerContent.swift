import Models
import SwiftUICore

struct TickerContent: View {
    var ticker: Ticker

    var body: some View {
        HStack {
            TickerInfo(ticker: ticker)
            Spacer()
            // chart
        }
        .padding()
        .frame(height: 160)
    }
}
