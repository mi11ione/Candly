import CoreDI
import CoreUI
import RepositoryInterfaces
import SwiftUI

struct PatternView: View {
    @Environment(\.diContainer) private var container: DIContainer
    @StateObject private var patternContainer: PatternContainer

    init() {
        _patternContainer = StateObject(wrappedValue: PatternContainer())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                filterView
                if patternContainer.state.isLoading {
                    ProgressView()
                } else {
                    patternsGrid
                }
            }
            .navigationTitle("Patterns")
        }
        .task {
            await setupContainer()
        }
    }

    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(patternContainer.state.filterKeys, id: \.self) { key in
                    FilterButton(
                        filter: key,
                        isSelected: patternContainer.state.selectedFilter == key,
                        action: {
                            Task {
                                await patternContainer.dispatch(.filterSelected(key))
                            }
                        }
                    )
                }
                Spacer()
            }
            .padding()
        }
        .padding(.top, -15)
    }

    private var patternsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
            ForEach(patternContainer.filteredPatterns, id: \.id) { pattern in
                PatternCell(
                    pattern: pattern,
                    isExpanded: patternContainer.state.expandedPatternId == pattern.id,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            patternContainer.toggleExpansion(for: pattern.id)
                        }
                    }
                )
                .id(pattern.id)
            }
        }
        .padding()
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: patternContainer.state.expandedPatternId)
    }

    private func setupContainer() async {
        let repository: PatternRepositoryProtocol = await container.resolve()
        patternContainer.setRepository(repository)
        await patternContainer.dispatch(.loadPatterns)
    }
}
