import Foundation

@Observable
open class BaseModel<T: Identifiable>: @unchecked Sendable {
    public private(set) var items: [T] = []
    public private(set) var searchText: String = ""
    public private(set) var isLoading: Bool = false
    public private(set) var error: String?
    public private(set) var expandedItemId: T.ID?

    public init() {}

    open func loadItems() async throws {
        fatalError("loadItems() has not been implemented")
    }

    public func load() {
        guard items.isEmpty else { return }

        Task { @MainActor in
            isLoading = true
            do {
                try await loadItems()
                error = nil
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    public func updateSearchText(_ newText: String) {
        searchText = newText
    }

    public func toggleItemExpansion(_ id: T.ID) {
        expandedItemId = expandedItemId == id ? nil : id
    }

    open var filteredItems: [T] {
        items
    }

    public func updateItems(_ newItems: [T]) {
        items = newItems
    }
}
