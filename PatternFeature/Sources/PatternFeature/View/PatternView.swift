import CoreUI
import SwiftUI

public struct PatternView: View {
    @State private var model: PatternModel

    public init(model: PatternModel) {
        _model = State(initialValue: model)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                FilterView(
                    filterKeys: model.filterKeys,
                    selectedFilter: model.selectedFilter,
                    onFilterSelected: { model.selectFilter($0) }
                )
                PatternGrid(
                    patterns: model.filteredItems,
                    expandedPatternId: model.expandedItemId,
                    onPatternTapped: { model.toggleItemExpansion($0) }
                )
            }
            .navigationTitle("Patterns")
        }
        .onAppear { model.load() }
    }
}
