import CoreUI
import ErrorHandling
import SwiftUI

struct PatternView: View {
    @StateObject private var container: PatternContainer

    init(container: @autoclosure @escaping () -> PatternContainer) {
        _container = StateObject(wrappedValue: container())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if container.state.isLoading {
                    ProgressView()
                } else if let error = container.state.error {
                    ErrorView(error: error) {
                        container.dispatch(.loadPatterns)
                    }
                } else {
                    ScrollView {
                        VStack {
                            filterView
                            patternsGrid
                        }
                    }
                }
            }
            .navigationTitle("Patterns")
        }
        .onAppear { container.dispatch(.loadPatterns) }
    }

    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(container.state.filterKeys, id: \.self) { key in
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
            ForEach(container.filteredPatterns) { pattern in
                PatternCell(
                    pattern: pattern,
                    isExpanded: container.state.expandedPatternId == pattern.id,
                    onTap: { container.dispatch(.togglePatternExpansion(pattern.id)) }
                )
                .id(pattern.id)
            }
        }
        .padding()
        .animation(.spring, value: container.state.expandedPatternId)
    }
}
