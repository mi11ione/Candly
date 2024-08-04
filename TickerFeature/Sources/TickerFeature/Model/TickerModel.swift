import Foundation
import RepositoryInterfaces
import SharedModels
import SwiftUI

@MainActor
public final class TickerModel: ObservableObject {
    @Published private(set) var state: TickerState
    private let repository: TickerRepositoryProtocol

    public init(repository: TickerRepositoryProtocol) {
        self.repository = repository
        state = TickerState()
    }

    public func process(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            loadTickers()
        case let .updateSearchText(newText):
            state.searchText = newText
        case let .toggleTickerExpansion(id):
            state.expandedTickerId = state.expandedTickerId == id ? nil : id
        }
    }

    private func loadTickers() {
        if !state.tickers.isEmpty { return }

        state.isLoading = true
        Task {
            do {
                state.tickers = try await repository.fetchTickers()
                state.error = nil
            } catch {
                state.error = error.localizedDescription
            }
            state.isLoading = false
        }
    }

    var filteredTickers: [TickerDTO] {
        guard !state.searchText.isEmpty else { return state.tickers }
        return state.tickers.filter { $0.title.lowercased().contains(state.searchText.lowercased()) }
    }
}

public struct TickerState: Equatable {
    var tickers: [TickerDTO] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var error: String?
    var expandedTickerId: UUID?
}
