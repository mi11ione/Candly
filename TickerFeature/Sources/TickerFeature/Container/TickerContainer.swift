import Combine
import RepositoryInterfaces
import SharedModels
import SwiftUI

@MainActor
class TickerContainer: ObservableObject {
    @Published var state: TickerState

    private let repository: TickerRepositoryProtocol

    init(repository: TickerRepositoryProtocol) {
        self.repository = repository
        state = TickerState()
    }

    func dispatch(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            loadTickers()
        case let .updateSearchText(newText):
            state.searchText = newText
        }
    }

    private func loadTickers() {
        Task {
            do {
                let tickers = try await repository.fetchTickers()
                self.state.tickers = tickers
            } catch {
                print("Error loading tickers: \(error)")
            }
        }
    }
}
