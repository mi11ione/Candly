import SwiftUI

public struct FilterView: View {
    private static let filterKeys = ["Single", "Double", "Triple", "Complex"]
    public var selectedFilter: String
    public var onFilterSelected: (String) -> Void

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
