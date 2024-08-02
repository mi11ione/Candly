import CoreUI
import RepositoryInterfaces
import SwiftUI

struct PatternView: View {
    @StateObject private var container: PatternContainer
    private let filterKeys = ["Single", "Double", "Triple", "Complex"]

    init(repository: PatternRepositoryProtocol) {
        _container = StateObject(wrappedValue: PatternContainer(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterView

                if container.state.isLoading {
                    ProgressView()
                } else {
                    patternsGrid
                }
            }
            .navigationTitle("Patterns")
        }
        .onAppear { container.dispatch(.loadPatterns) }
    }

    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filterKeys, id: \.self) { key in
                    FilterButton(
                        filter: key,
                        isSelected: container.state.selectedFilter == key,
                        action: { container.dispatch(.filterSelected(key)) }
                    )
                }
                Spacer()
            }
            .padding()
        }
    }

    private var patternsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                ForEach(container.filteredPatterns, id: \.id) { pattern in
                    PatternCell(pattern: pattern,
                                isExpanded: pattern.id == container.state.expandedPatternId,
                                onTap: { container.dispatch(.patternExpanded(pattern.id)) })
                        .id(pattern.id)
                }
            }
            .padding()
        }
    }
}
