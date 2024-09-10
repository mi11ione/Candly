import Factory

public extension Container {
    var modelContext: Factory<ModelContextProtocol> {
        self { PersistenceActor.shared }
    }
}
