import Foundation

@Observable
open class BaseModel<T: Identifiable, I> {
    public private(set) var items: [T] = []
    public private(set) var searchText: String = ""
    public private(set) var isLoading: Bool = false
    public private(set) var error: String?

    public init() {}

    open func loadItems() async throws {
        fatalError("loadItems() has not been implemented")
    }

    @MainActor
    open func handle(_: I) {
        fatalError("handle(_:) has not been implemented")
    }

    @MainActor
    public func load() {
        guard items.isEmpty else { return }

        Task {
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

    open var filteredItems: [T] {
        items
    }

    public func updateItems(_ newItems: [T]) {
        items = newItems
    }
}
