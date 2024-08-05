import CoreArchitecture
import CoreUI
import SharedModels
import SwiftUI

public struct PatternView: BaseView {
    public typealias T = Pattern
    public typealias I = PatternIntent
    @State public var model: PatternModel

    public var body: some View {
        NavigationStack {
            ScrollView {
                FilterView(
                    filterKeys: model.filterKeys,
                    selectedFilter: model.selectedFilter,
                    onFilterSelected: { handleIntent(.filterSelected($0)) }
                )
                PatternGrid(
                    patterns: model.filteredItems,
                    expandedPatternId: model.expandedItemId,
                    onPatternTapped: { handleIntent(.togglePatternExpansion($0)) }
                )
            }
            .navigationTitle("Patterns")
        }
        .onAppear { handleIntent(.loadPatterns) }
    }
}
