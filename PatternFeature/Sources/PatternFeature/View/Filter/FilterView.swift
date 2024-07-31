import SwiftUI

struct FilterView: View {
    let selectedFilter: String
    let filterKeys: [String]
    let onFilterTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filterKeys, id: \.self) { key in
                    FilterButton(filter: key,
                                 isSelected: selectedFilter == key,
                                 action: { onFilterTap(key) })
                }
                Spacer()
            }
            .padding()
        }
    }
}
