import Core
import Data
import Foundation
import Models

@Observable
public final class PatternModel: BaseModel<Pattern, PatternIntent> {
    @ObservationIgnored private let fetchPatternsUseCase: FetchPatternsUseCaseProtocol
    public var selectedFilter: String = FilterModel.allPatterns.rawValue

    public init(fetchPatternsUseCase: FetchPatternsUseCaseProtocol) {
        self.fetchPatternsUseCase = fetchPatternsUseCase
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedPatterns = try await fetchPatternsUseCase.execute()
        let sortedPatterns = fetchedPatterns.map { pattern in
            Pattern(
                id: pattern.id,
                name: pattern.name,
                info: pattern.info,
                filter: pattern.filter,
                candles: pattern.candles.sorted(by: { $0.date < $1.date })
            )
        }
        updateItems(sortedPatterns)
    }

    override public var filteredItems: [Pattern] {
        selectedFilter.isEmpty || selectedFilter == "All Patterns" ? items : items.filter { $0.filter == selectedFilter }
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
