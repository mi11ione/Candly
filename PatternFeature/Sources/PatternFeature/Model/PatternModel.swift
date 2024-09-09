import CoreArchitecture
import Domain
import Foundation
import SharedModels

@Observable
public final class PatternModel: BaseModel<Pattern, PatternIntent>, @unchecked Sendable {
    private let fetchPatternsUseCase: FetchPatternsUseCaseProtocol
    public private(set) var selectedFilter: String = ""

    public init(fetchPatternsUseCase: FetchPatternsUseCaseProtocol) {
        self.fetchPatternsUseCase = fetchPatternsUseCase
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedPatterns = try await fetchPatternsUseCase.execute()
        updateItems(fetchedPatterns)
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
            selectedFilter = selectedFilter == filter ? "" : filter
        }
    }
}
