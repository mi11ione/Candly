import PatternFeature
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PatternFeature()
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
