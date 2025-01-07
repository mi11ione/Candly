import Core
import Models
import SwiftUI

struct PatternView: BaseView {
    typealias T = Models.Pattern
    typealias I = PatternIntent
    @State var model: PatternModel

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    FilterView(activeFilter: $model.selectedFilter)
                    Spacer()
                }
                PatternGrid(patterns: model.filteredItems)
            }
            .navigationTitle("Patterns")
        }
        .onAppear { handleIntent(.loadPatterns) }
    }
}
