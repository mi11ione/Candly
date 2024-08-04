import CoreDI
import SwiftData
import SwiftUI

@main
struct CandlyApp: App {
    @State private var container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .inject(container as DIContainer)
                .modelContainer(container.modelContainer)
        }
    }
}
