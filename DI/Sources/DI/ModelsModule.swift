import Factory
import Models

extension Container {
    var modelContext: Factory<ModelContextProtocol> {
        self { PersistenceActor.shared }.singleton
    }
}
