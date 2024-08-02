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

    func dispatch(_ intent: PatternIntent) {
        switch intent {
        case .loadPatterns:
            handleLoadPatterns()
        case let .filterSelected(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        }
    }

    private func handleLoadPatterns() {
        state.isLoading = true
        Task {
            let patterns = await repository.fetchPatterns()
            state.patterns = patterns
            state.isLoading = false
        }
    }

    var filteredPatterns: [PatternDTO] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
