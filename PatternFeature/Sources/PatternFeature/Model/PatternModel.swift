import Foundation
import RepositoryInterfaces
import SharedModels

@MainActor
public final class PatternModel: ObservableObject {
    @Published private(set) var state: PatternState
    private let repository: PatternRepositoryProtocol

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
        state = PatternState()
    }

    public func process(_ intent: PatternIntent) {
        switch intent {
        case .loadPatterns:
            loadPatterns()
        case let .filterSelected(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        case let .togglePatternExpansion(id):
            state.expandedPatternId = state.expandedPatternId == id ? nil : id
        }
    }

    private func loadPatterns() {
        state.isLoading = true
        Task {
            do {
                state.patterns = try await repository.fetchPatterns()
                state.error = nil
            } catch {
                state.error = error.localizedDescription
            }
            state.isLoading = false
        }
    }

    var filteredPatterns: [PatternDTO] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}

public struct PatternState: Equatable {
    var patterns: [PatternDTO] = []
    var selectedFilter: String = ""
    var isLoading: Bool = false
    var error: String?
    var expandedPatternId: UUID?
    let filterKeys = ["Single", "Double", "Triple", "Complex"]
}
