import SwiftUI

struct FilterView: View {
    @Binding var activeFilter: String

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 8) {
                HStack(spacing: activeFilter == "All Patterns" ? -15 : 8) {
                    ForEach(FilterModel.allCases.filter { $0 != .allPatterns }, id: \.rawValue) { filter in
                        FilterButton(activeFilter: $activeFilter, filter: filter)
                    }
                }

                if activeFilter == "All Patterns" {
                    FilterButton(activeFilter: $activeFilter, filter: .allPatterns)
                        .transition(.offset(x: geo.size.width - (40 * CGFloat(FilterModel.allCases.count - 1))).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: 450)
        .frame(height: 48)
        .padding(.bottom, 10)
    }
}
