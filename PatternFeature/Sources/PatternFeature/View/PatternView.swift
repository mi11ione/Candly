import CoreUI
import SwiftUI

public struct PatternView: View {
    @StateObject var model: PatternModel

    public init(model: PatternModel) {
        _model = StateObject(wrappedValue: model)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                filterView
                patternsGrid
            }
            .navigationTitle("Patterns")
        }
        .onAppear { model.process(.loadPatterns) }
    }

    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(model.state.filterKeys, id: \.self) { key in
                    FilterButton(
                        filter: key,
                        isSelected: model.state.selectedFilter == key,
                        action: { model.process(.filterSelected(key)) }
                    )
                }
                Spacer()
            }
            .padding()
        }
    }

    private var patternsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
            ForEach(model.filteredPatterns) { pattern in
                PatternCell(
                    pattern: pattern,
                    isExpanded: model.state.expandedPatternId == pattern.id,
                    onTap: { model.process(.togglePatternExpansion(pattern.id)) }
                )
                .id(pattern.id)
            }
        }
        .padding()
        .animation(.spring, value: model.state.expandedPatternId)
    }
}
