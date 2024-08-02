import CoreDI
import SwiftData
import SwiftUI

@main
struct CandlyApp: App {
    @StateObject private var container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            if let modelContainer = container.modelContainer {
                ContentView()
                    .inject(container as DIContainer)
                    .modelContainer(modelContainer)
            } else {
                EmptyView()
            }
        }
    }
}
