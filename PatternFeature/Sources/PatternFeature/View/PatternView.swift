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
