import CoreDI
import SwiftData
import SwiftUI

@main
struct CandlyApp: App {
    @StateObject private var container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .inject(container as DIContainer)
                .modelContainer(container.modelContainer)
        }
    }
}
