import CoreDI
import SwiftUI

@main
@MainActor struct CandlyApp: App {
    @State private var dependencyFactory = AppDependency()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencyFactory, dependencyFactory)
        }
    }
}
