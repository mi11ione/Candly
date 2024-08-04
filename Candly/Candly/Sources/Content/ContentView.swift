import PatternFeature
import SwiftUI
import TickerFeature

struct ContentView: View {
    var body: some View {
        TabView {
            PatternFeature()
                .tabItem {
                    Label("Patterns", systemImage: "alternatingcurrent")
                }

            TickerFeature()
                .tabItem {
                    Label("Tickers", systemImage: "dollarsign.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
