import SwiftData

public struct DataWrapper<T: Sendable>: Sendable {
    private let value: T

    public init(value: T) {
        self.value = value
    }
}

@MainActor
public protocol ModelContextProtocol: Sendable {
    func insert(_ model: any PersistentModel)
    func delete(_ model: any PersistentModel)
    func save() throws
    func fetch<T: PersistentModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]
}
