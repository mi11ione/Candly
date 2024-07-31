import Combine
import SwiftUI

@MainActor
class PatternContainer: ObservableObject {
    @Published private(set) var state: PatternState
    private let repository: PatternRepository

    init(repository: PatternRepository) {
        self.repository = repository
        state = PatternState()
    }

    func dispatch(_ intent: PatternIntent) {
        switch intent {
        case .loadPatterns:
            Task {
                let patterns = await repository.fetchPatterns()
                state.patterns = patterns
            }
        case let .selectFilter(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        case let .toggleExpandPattern(patternId):
            state.expandedPatternId = state.expandedPatternId == patternId ? nil : patternId
        }
    }

    var filteredPatterns: [PatternDTO] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}

struct PatternState {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var expandedPatternId: UUID?
}
