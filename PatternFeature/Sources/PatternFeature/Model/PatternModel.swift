import CoreArchitecture
import Foundation
import RepositoryInterfaces
import SharedModels

@MainActor
public final class PatternModel: BaseModel<PatternDTO> {
    private let repository: PatternRepositoryProtocol
    public let filterKeys = ["Single", "Double", "Triple", "Complex"]
    @Published public var selectedFilter: String = ""

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    override public func loadItems() async throws {
        items = try await repository.fetchPatterns()
    }

    public func selectFilter(_ filter: String) {
        selectedFilter = selectedFilter == filter ? "" : filter
    }

    override public var filteredItems: [PatternDTO] {
        guard !selectedFilter.isEmpty else { return items }
        return items.filter { $0.filter.lowercased() == selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
