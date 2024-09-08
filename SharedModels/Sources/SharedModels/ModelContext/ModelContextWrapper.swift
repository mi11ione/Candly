import SwiftData

@MainActor
public final class ModelContextWrapper: ModelContextProtocol, Sendable {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func insert(_ model: any PersistentModel) {
        context.insert(model)
    }

    public func delete(_ model: any PersistentModel) {
        context.delete(model)
    }

    public func save() throws {
        try context.save()
    }

    public func fetch<T: PersistentModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T] {
        try context.fetch(fetchDescriptor)
    }
}
