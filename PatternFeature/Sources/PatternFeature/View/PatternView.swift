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
                    filterKeys: model.state.filterKeys,
                    selectedFilter: model.state.selectedFilter,
                    onFilterSelected: { model.process(.filterSelected($0)) }
                )
                PatternGridView(
                    patterns: model.filteredPatterns,
                    expandedPatternId: model.state.expandedPatternId,
                    onPatternTapped: { model.process(.togglePatternExpansion($0)) }
                )
            }
            .navigationTitle("Patterns")
        }
        .onAppear { model.process(.loadPatterns) }
    }
}
