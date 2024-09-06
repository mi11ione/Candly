import SwiftData

@MainActor
public protocol ModelContextWrapperProtocol: Sendable {
    func fetch<T: PersistentModel, Model: Sendable>(_ descriptor: FetchDescriptor<T>, transform: (T) -> Model) throws -> [Model]
    func insert(_ object: some PersistentModel)
    func insertMultiple(_ objects: [some PersistentModel])
    func save() throws
}
