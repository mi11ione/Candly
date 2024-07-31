import CoreUI
import SwiftUI

struct PatternView: View {
    @StateObject private var container: PatternContainer
    private let filterKeys = ["Single", "Double", "Triple", "Complex"]

    init(repository: PatternRepository) {
        _container = StateObject(wrappedValue: PatternContainer(repository: repository))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                FilterView(selectedFilter: container.state.selectedFilter,
                           filterKeys: filterKeys,
                           onFilterTap: { container.dispatch(.selectFilter($0)) })

                patternsGrid
            }
            .navigationTitle("Patterns")
        }
        .onAppear { container.dispatch(.loadPatterns) }
    }

    private var patternsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
            ForEach(container.filteredPatterns) { pattern in
                PatternCell(pattern: pattern,
                            isExpanded: pattern.id == container.state.expandedPatternId,
                            onTap: { container.dispatch(.toggleExpandPattern(pattern.id)) })
            }
        }
        .padding()
    }
}
