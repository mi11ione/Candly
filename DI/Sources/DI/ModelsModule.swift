import Factory
import Models
import SwiftData

extension Container {
    var modelContainer: Factory<ModelContainer> {
        self { try! ModelContainer(for: Pattern.self, Ticker.self, Candle.self) }.singleton
    }
}
