import CoreArchitecture
import Foundation
import RepositoryInterfaces
import SharedModels

@Observable
public final class TickerModel: BaseModel<TickerDTO>, @unchecked Sendable {
    private let repository: TickerRepositoryProtocol

    public init(repository: TickerRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    override public func loadItems() async throws {
        let fetchedTickers = try await repository.fetchTickers()
        updateItems(fetchedTickers)
    }

    override public var filteredItems: [TickerDTO] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
