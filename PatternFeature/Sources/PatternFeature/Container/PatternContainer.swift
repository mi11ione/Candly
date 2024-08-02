import Foundation
import RepositoryInterfaces
import SharedModels

@MainActor
class PatternContainer: ObservableObject {
    @Published private(set) var state: PatternState
    private let repository: PatternRepositoryProtocol

    init(repository: PatternRepositoryProtocol) {
        self.repository = repository
        state = PatternState()
    }

    func dispatch(_ action: PatternAction) {
        switch action {
        case .loadPatterns:
            loadPatterns()
        case let .patternsLoaded(patterns):
            state.patterns = patterns
            state.isLoading = false
        case let .filterSelected(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        case let .patternExpanded(patternId):
            state.expandedPatternId = state.expandedPatternId == patternId ? nil : patternId
        }
    }

    private func loadPatterns() {
        state.isLoading = true
        Task {
            let patterns = await repository.fetchPatterns()
            dispatch(.patternsLoaded(patterns))
        }
    }

    var filteredPatterns: [PatternDTO] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
