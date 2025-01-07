import SwiftUI

struct FilterView: View {
    @Binding var activeFilter: String

    var body: some View {
        ScrollView(.vertical) {
            Filter(activeFilter: $activeFilter)
                .frame(alignment: .top)
                .padding(.bottom, 10)
        }
    }
}
