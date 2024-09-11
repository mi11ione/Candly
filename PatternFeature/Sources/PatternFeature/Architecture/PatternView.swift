import Core
import Models
import SwiftUI

public struct PatternView: BaseView {
    public typealias T = Pattern
    public typealias I = PatternIntent
    @State public var model: PatternModel

    public var body: some View {
        NavigationStack {
            ScrollView {
                FilterView(
                    selectedFilter: model.selectedFilter,
                    onFilterSelected: { filter in
                        handleIntent(.filterSelected(filter))
                    }
                )
                PatternGrid(patterns: model.filteredItems)
            }
            .navigationTitle("Patterns")
        }
        .onAppear { handleIntent(.loadPatterns) }
    }
}
