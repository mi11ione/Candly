import Foundation
import RepositoryInterfaces
import SharedModels
import SwiftUI

@MainActor
public final class TickerModel: ObservableObject {
    @Published private(set) var tickers: [TickerDTO] = []
    @Published var searchText: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    @Published var expandedTickerId: UUID?

    private let repository: TickerRepositoryProtocol

    public init(repository: TickerRepositoryProtocol) {
        self.repository = repository
    }

    public func loadTickers() {
        guard tickers.isEmpty else { return }

        isLoading = true
        Task {
            do {
                tickers = try await repository.fetchTickers()
                error = nil
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    public func updateSearchText(_ newText: String) {
        searchText = newText
    }

    public func toggleTickerExpansion(_ id: UUID) {
        expandedTickerId = expandedTickerId == id ? nil : id
    }

    var filteredTickers: [TickerDTO] {
        guard !searchText.isEmpty else { return tickers }
        return tickers.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
