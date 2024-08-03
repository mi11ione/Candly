import RepositoryInterfaces
import SharedModels
import SwiftUI

@MainActor
final class TickerContainer: ObservableObject {
    @Published private(set) var state: TickerState
    private let repository: TickerRepositoryProtocol

    init(repository: TickerRepositoryProtocol) {
        self.repository = repository
        state = TickerState()
    }

    func dispatch(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            Task { await loadTickers() }
        case let .updateSearchText(newText):
            state.searchText = newText
        case let .toggleTickerExpansion(id):
            state.expandedTickerId = state.expandedTickerId == id ? nil : id
        }
    }

    private func loadTickers() async {
        if !state.tickers.isEmpty { return }

        state.isLoading = true
        do {
            state.tickers = try await repository.fetchTickers()
            state.error = nil
        } catch {
            state.error = error.localizedDescription
        }
        state.isLoading = false
    }

    var filteredTickers: [TickerDTO] {
        guard !state.searchText.isEmpty else { return state.tickers }
        return state.tickers.filter { $0.title.lowercased().contains(state.searchText.lowercased()) }
    }
}
