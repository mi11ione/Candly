import Foundation
import RepositoryInterfaces
import SharedModels

@MainActor
class PatternContainer: ObservableObject {
    @Published private(set) var state: PatternState
    private var repository: PatternRepositoryProtocol?

    init() {
        state = PatternState()
    }

    func setRepository(_ repository: PatternRepositoryProtocol) {
        self.repository = repository
    }

    func dispatch(_ intent: PatternIntent) async {
        switch intent {
        case .loadPatterns:
            await handleLoadPatterns()
        case let .filterSelected(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        }
    }

    private func handleLoadPatterns() async {
        guard let repository else { return }
        state.isLoading = true
        let patterns = await repository.fetchPatterns()
        state.patterns = patterns
        state.isLoading = false
    }

    var filteredPatterns: [PatternDTO] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
