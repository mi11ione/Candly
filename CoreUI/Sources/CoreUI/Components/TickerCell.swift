import SharedModels
import SwiftUI

public struct TickerCell: View {
    let ticker: TickerDTO
    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme

    public init(ticker: TickerDTO) {
        self.ticker = ticker
    }

    public var body: some View {
        VStack {
            tickerInformation
                .padding()
                .frame(width: 350, height: 160)
                .background(backgroundColor)
                .cornerRadius(30)
                .shadow(color: shadowColor, radius: 7, x: 0, y: 0)

            if isExpanded {
                expandedView
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(overlayColor)
                )
        )
        .onTapGesture {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }
    }

    private var tickerInformation: some View {
        HStack {
            tickerDetails
            Spacer()
            // chart placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 50)
        }
    }

    private var expandedView: some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Additional Information")
                .font(.subheadline)
                .bold()
                .padding(2)

            Text("This is where you can add more details about the ticker.")
                .font(.caption)
        }
        .frame(width: 350)
        .padding(.top)
    }

    private var tickerDetails: some View {
        VStack(alignment: .leading) {
            Text(ticker.subTitle)
                .font(.title3)
                .bold()
            Text("$\(ticker.title)")
            Text(String(format: "%.2f", ticker.price))
                .font(.title3)
                .bold()
            Text(priceChangeText)
                .foregroundColor(priceChangeColor)
        }
    }

    private var priceChangeText: String {
        let change = String(format: "%.2f", abs(ticker.priceChange))
        return ticker.priceChange >= 0 ? "+\(change)" : "-\(change)"
    }

    private var priceChangeColor: Color {
        ticker.priceChange >= 0 ? .green : .red
    }

    private var overlayColor: Color {
        isExpanded ? (colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)) : Color.clear
    }

    private var shadowColor: Color {
        isExpanded ? (colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.4)) : (colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.2))
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : .white
    }
}
