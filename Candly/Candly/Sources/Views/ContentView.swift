import PatternFeature
import SwiftUI
import CoreUI
import CoreDI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            PatternFeature(repository: PatternRepository(modelContext: modelContext))
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
