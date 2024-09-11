import Factory
import SharedModels

public extension Container {
    var modelContext: Factory<ModelContextProtocol> {
        self { PersistenceActor.shared }.singleton
    }
}
