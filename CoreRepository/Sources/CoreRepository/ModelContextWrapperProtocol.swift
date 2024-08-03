import SwiftData

@MainActor
public protocol ModelContextWrapperProtocol {
    func fetch<T: PersistentModel, DTO: Sendable>(_ descriptor: FetchDescriptor<T>, transform: (T) -> DTO) throws -> [DTO]
    func insert(_ object: some PersistentModel)
    func insertMultiple(_ objects: [some PersistentModel])
    func save() throws
}
