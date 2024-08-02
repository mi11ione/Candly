import Combine
import NetworkService
import RepositoryInterfaces
import SharedModels
import SwiftUI

@MainActor
class TickerContainer: ObservableObject {
    @Published private(set) var state: TickerState

    private let repository: TickerRepositoryProtocol

    init(repository: TickerRepositoryProtocol) {
        self.repository = repository
        state = TickerState()
    }

    func dispatch(_ intent: TickerIntent) {
        switch intent {
        case .loadTickers:
            handleLoadTickers()
        case let .updateSearchText(newText):
            state.searchText = newText
        case .dismissError:
            state.error = nil
        }
    }

    private func handleLoadTickers() {
        state.isLoading = true
        Task {
            do {
                let tickers = try await repository.fetchTickers()
                state.tickers = tickers
                state.isLoading = false
                state.error = nil
            } catch {
                state.error = handleError(error)
                state.isLoading = false
            }
        }
    }

    private func handleError(_ error: Error) -> String {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                "Invalid URL. Please check the API endpoint."
            case .invalidResponse:
                "Invalid response from the server. Please try again later."
            case .decodingError:
                "Error decoding the data. Please try again later."
            case .hostNotFound:
                "Unable to connect to the server. Please check your internet connection and try again."
            case .requestFailed:
                "Request failed. Please try again later."
            }
        } else {
            "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
