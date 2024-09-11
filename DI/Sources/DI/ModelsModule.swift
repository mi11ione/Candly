import Factory
import Models

public extension Container {
    var modelContext: Factory<ModelContextProtocol> {
        self { PersistenceActor.shared }.singleton
    }
}
