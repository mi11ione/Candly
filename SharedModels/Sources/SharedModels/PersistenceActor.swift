import SwiftData

@ModelActor
public final actor PersistenceActor: ModelContextProtocol {
    public static let shared = PersistenceActor(modelContainer: try! PersistenceActor.createContainer())

    private static func createContainer() throws -> ModelContainer {
        let schema = Schema([Pattern.self, Ticker.self, Candle.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }

    public func insert(_ model: any(PersistentModel & Sendable)) {
        modelContext.insert(model)
    }

    public func delete(_ model: any(PersistentModel & Sendable)) {
        modelContext.delete(model)
    }

    public func save() throws {
        try modelContext.save()
    }

    public func fetch<T: PersistentModel & Sendable>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T] {
        try modelContext.fetch(fetchDescriptor)
    }
}

public protocol ModelContextProtocol: Sendable, Actor {
    func insert(_ model: any(PersistentModel & Sendable))
    func delete(_ model: any(PersistentModel & Sendable))
    func save() throws
    func fetch<T: PersistentModel & Sendable>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]
}
