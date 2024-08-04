import Foundation
import RepositoryInterfaces
import SharedModels

@MainActor
public final class PatternModel: ObservableObject {
    @Published private(set) var patterns: [PatternDTO] = []
    @Published var selectedFilter: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    @Published var expandedPatternId: UUID?

    private let repository: PatternRepositoryProtocol
    public let filterKeys = ["Single", "Double", "Triple", "Complex"]

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
    }

    public func loadPatterns() {
        isLoading = true
        Task {
            do {
                patterns = try await repository.fetchPatterns()
                error = nil
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    public func selectFilter(_ filter: String) {
        selectedFilter = selectedFilter == filter ? "" : filter
    }

    public func togglePatternExpansion(_ id: UUID) {
        expandedPatternId = expandedPatternId == id ? nil : id
    }

    var filteredPatterns: [PatternDTO] {
        guard !selectedFilter.isEmpty else { return patterns }
        return patterns.filter { $0.filter.lowercased() == selectedFilter.lowercased() }
            .sorted { $0.id.uuidString < $1.id.uuidString }
    }
}
