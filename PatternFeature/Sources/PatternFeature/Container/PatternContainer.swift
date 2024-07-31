import Combine
import SwiftUI

@MainActor
class PatternContainer: ObservableObject {
    @Published private(set) var state: PatternState

    init(initialState: PatternState = PatternState()) {
        state = initialState
    }

    func dispatch(_ intent: PatternIntent) {
        switch intent {
        case .loadPatterns:
            state.patterns = PatternRepository.fetchPatterns()
        case let .selectFilter(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        case let .toggleExpandPattern(patternId):
            state.expandedPatternId = state.expandedPatternId == patternId ? nil : patternId
        }
    }

    var filteredPatterns: [Pattern] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
