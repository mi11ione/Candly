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
                PatternGridView(
                    patterns: model.filteredPatterns,
                    expandedPatternId: model.expandedPatternId,
                    onPatternTapped: { model.togglePatternExpansion($0) }
                )
            }
            .navigationTitle("Patterns")
        }
        .onAppear { model.loadPatterns() }
    }
}
