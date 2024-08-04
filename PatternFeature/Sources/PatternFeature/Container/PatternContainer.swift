import ErrorHandling
import Foundation
import RepositoryInterfaces
import SharedModels

@MainActor
final class PatternContainer: ObservableObject {
    @Published private(set) var state: PatternState
    private let repository: PatternRepositoryProtocol
    private let errorHandler: ErrorHandling

    init(repository: PatternRepositoryProtocol, errorHandler: ErrorHandling = DefaultErrorHandler()) {
        self.repository = repository
        self.errorHandler = errorHandler
        state = PatternState()
    }

    func dispatch(_ intent: PatternIntent) {
        switch intent {
        case .loadPatterns:
            Task { await loadPatterns() }
        case let .filterSelected(filter):
            state.selectedFilter = state.selectedFilter == filter ? "" : filter
        case let .togglePatternExpansion(id):
            state.expandedPatternId = state.expandedPatternId == id ? nil : id
        }
    }

    private func loadPatterns() async {
        state.isLoading = true
        do {
            state.patterns = try await repository.fetchPatterns()
            state.error = nil
        } catch {
            let appError = errorHandler.handle(error)
            state.error = appError.localizedDescription
        }
        state.isLoading = false
    }

    var filteredPatterns: [PatternDTO] {
        guard !state.selectedFilter.isEmpty else { return state.patterns }
        return state.patterns.filter { $0.filter.lowercased() == state.selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
