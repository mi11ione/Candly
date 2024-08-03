import SwiftData

@MainActor
public class ModelContextWrapper: ModelContextWrapperProtocol {
    private let context: ModelContext

    public init(_ context: ModelContext) {
        self.context = context
    }

    public func fetch<T: PersistentModel, DTO: Sendable>(_ descriptor: FetchDescriptor<T>, transform: (T) -> DTO) throws -> [DTO] {
        try context.fetch(descriptor).map(transform)
    }

    public func insert(_ object: some PersistentModel) {
        context.insert(object)
    }

    public func insertMultiple(_ objects: [some PersistentModel]) {
        objects.forEach { context.insert($0) }
    }

    public func save() throws {
        try context.save()
    }
}
