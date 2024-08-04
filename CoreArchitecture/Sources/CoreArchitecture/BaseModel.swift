import Foundation

@MainActor
open class BaseModel<T: Identifiable>: ObservableObject {
    @Published public var items: [T] = []
    @Published public var searchText: String = ""
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var error: String?
    @Published public var expandedItemId: T.ID?

    public init() {}

    open func loadItems() async throws {
        fatalError("loadItems() has not been implemented")
    }

    public func load() {
        guard items.isEmpty else { return }

        isLoading = true
        Task {
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
}
