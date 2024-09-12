import SwiftUI

struct FilterView: View {
    let filterKeys = ["Single", "Double", "Triple", "Complex"]
    var selectedFilter: String
    var onFilterSelected: (String) -> Void

    var body: some View {
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
