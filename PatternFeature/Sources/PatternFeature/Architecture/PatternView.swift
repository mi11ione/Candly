import Core
import Models
import SwiftUI

struct PatternView: BaseView {
    typealias T = Pattern
    typealias I = PatternIntent
    @State var model: PatternModel

    var body: some View {
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
