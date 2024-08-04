import CoreDI
import SwiftUI

@main
struct CandlyApp: App {
    @State private var dependencyFactory = AppDependency()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencyFactory, dependencyFactory)
        }
    }
}
