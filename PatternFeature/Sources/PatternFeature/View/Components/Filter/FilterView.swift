import SwiftUI

public struct FilterView: View {
    private static let filterKeys = ["Single", "Double", "Triple", "Complex"]
    private let selectedFilter: String
    private let onFilterSelected: (String) -> Void

    public init(selectedFilter: String, onFilterSelected: @escaping (String) -> Void) {
        self.selectedFilter = selectedFilter
        self.onFilterSelected = onFilterSelected
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Self.filterKeys, id: \.self) { key in
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
