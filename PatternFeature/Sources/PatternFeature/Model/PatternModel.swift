import CoreArchitecture
import CoreRepository
import Foundation
import SharedModels

@Observable
public final class PatternModel: BaseModel<Pattern, PatternIntent>, @unchecked Sendable {
    private let repository: PatternRepositoryProtocol
    public let filterKeys = ["Single", "Double", "Triple", "Complex"]
    public private(set) var selectedFilter: String = ""

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedPatterns = try await repository.fetchPatterns()
        updateItems(fetchedPatterns)
    }

    public func selectFilter(_ filter: String) {
        selectedFilter = selectedFilter == filter ? "" : filter
    }

    override public var filteredItems: [Pattern] {
        guard !selectedFilter.isEmpty else { return items }
        return items.filter { $0.filter.lowercased() == selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }

    override public func handle(_ intent: PatternIntent) {
        switch intent {
        case .loadPatterns:
            load()
        case let .filterSelected(filter):
            selectFilter(filter)
        case let .togglePatternExpansion(id):
            toggleItemExpansion(id)
        }
    }
}
