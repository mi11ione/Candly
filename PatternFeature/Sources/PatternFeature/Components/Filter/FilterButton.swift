import Core
import SwiftUICore

struct FilterButton: View {
    var filter: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        SelectButton(isSelected: isSelected, action: action) {
            Text(filter)
        }
        .padding(.horizontal, 2)
    }
}
