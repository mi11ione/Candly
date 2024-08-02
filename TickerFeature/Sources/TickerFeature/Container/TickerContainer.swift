import Combine
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftUI

@MainActor
class TickerContainer: ObservableObject {
    @Published private(set) var state: TickerState

    private var repository: TickerRepositoryProtocol?
    private(set) var hasLoadedData = false

    init() {
        state = TickerState()
    }

    func setRepository(_ repository: TickerRepositoryProtocol) {
        self.repository = repository
    }

    func dispatch(_ intent: TickerIntent) async {
        switch intent {
        case .loadTickers:
            await handleLoadTickers()
        case let .updateSearchText(newText):
            state.searchText = newText
        case .dismissError:
            state.error = nil
        }
    }

    private func handleLoadTickers() async {
        guard let repository, !hasLoadedData else { return }

        state.isLoading = true
        do {
            let tickers = try await repository.fetchTickers()
            state.tickers = tickers
            state.isLoading = false
            state.error = nil
            hasLoadedData = true
        } catch {
            state.error = error.localizedDescription
            state.isLoading = false
        }
    }
}
