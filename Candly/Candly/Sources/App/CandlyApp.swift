import CoreRepository
import SwiftData
import SwiftUI
import SharedModels

@main
struct CandlyApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Pattern.self, Candle.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
