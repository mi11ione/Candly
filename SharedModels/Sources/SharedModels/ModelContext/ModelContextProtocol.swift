import SwiftData

@MainActor
public protocol ModelContextProtocol: Sendable {
    func insert(_ model: any PersistentModel)
    func delete(_ model: any PersistentModel)
    func save() throws
    func fetch<T: PersistentModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]
}
