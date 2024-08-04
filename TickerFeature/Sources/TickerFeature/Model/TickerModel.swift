import CoreArchitecture
import RepositoryInterfaces
import SharedModels

@MainActor
public final class TickerModel: BaseModel<TickerDTO> {
    private let repository: TickerRepositoryProtocol

    public init(repository: TickerRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    override public func loadItems() async throws {
        items = try await repository.fetchTickers()
    }

    override public var filteredItems: [TickerDTO] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
