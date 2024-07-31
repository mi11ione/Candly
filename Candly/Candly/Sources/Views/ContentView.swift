import PatternFeature
import SharedModels
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            PatternFeature(repository: PatternRepository(modelContext: ModelContextWrapper(modelContext)))
                .tabItem {
                    Label("Patterns", systemImage: "chart.bar.fill")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
