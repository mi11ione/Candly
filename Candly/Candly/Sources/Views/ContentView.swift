import CoreRepository
import NetworkService
import PatternFeature
import SharedModels
import SwiftData
import SwiftUI
import TickerFeature

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            PatternFeature(repository: PatternRepository(modelContext: ModelContextWrapper(modelContext)))
                .tabItem {
                    Label("Patterns", systemImage: "chart.bar.fill")
                }
            
            TickerFeature(repository: TickerRepository(
                modelContext: ModelContextWrapper(modelContext),
                tradingDataService: TradingDataService()
            ))
            .tabItem {
                Label("Tickers", systemImage: "dollarsign.circle.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
