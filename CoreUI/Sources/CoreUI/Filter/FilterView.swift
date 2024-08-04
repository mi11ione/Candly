import SwiftUI

public struct FilterView: View {
    let filterKeys: [String]
    let selectedFilter: String
    let onFilterSelected: (String) -> Void

    public init(filterKeys: [String], selectedFilter: String, onFilterSelected: @escaping (String) -> Void) {
        self.filterKeys = filterKeys
        self.selectedFilter = selectedFilter
        self.onFilterSelected = onFilterSelected
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filterKeys, id: \.self) { key in
                    FilterButton(
                        filter: key,
                        isSelected: selectedFilter == key,
                        action: { onFilterSelected(key) }
                    )
                }
                Spacer()
            }
            .padding()
        }
    }
}
