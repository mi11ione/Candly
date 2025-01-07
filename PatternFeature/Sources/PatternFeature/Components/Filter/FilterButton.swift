import SwiftUICore

struct Filter: View {
    @Binding var activeFilter: String

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 8) {
                HStack(spacing: activeFilter == "All Patterns" ? -15 : 8) {
                    ForEach(FilterModel.allCases.filter { $0 != .allPatterns }, id: \.rawValue) { filter in
                        ResizableFilterButton(filter)
                    }
                }

                if activeFilter == "All Patterns" {
                    ResizableFilterButton(.allPatterns)
                        .transition(.offset(x: geo.size.width - (40 * CGFloat(FilterModel.allCases.count - 1))))
                }
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 48)
    }

    @ViewBuilder
    func ResizableFilterButton(_ filter: FilterModel) -> some View {
        HStack(spacing: 8) {
            Image(systemName: filter.symbolImage)
                .opacity(activeFilter != filter.rawValue ? 1 : 0)
                .overlay {
                    Image(systemName: filter.symbolImage)
                        .symbolVariant(.fill)
                        .opacity(activeFilter == filter.rawValue ? 1 : 0)
                }

            if activeFilter == filter.rawValue {
                Text(filter.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(filter == .allPatterns ? Color("InvertedTextColor") : activeFilter == filter.rawValue ? .white : .gray)
        .frame(maxWidth: activeFilter == filter.rawValue ? .infinity : nil, maxHeight: .infinity)
        .padding(.horizontal, activeFilter == filter.rawValue ? 10 : 20)
        .background(Rectangle().fill(activeFilter == filter.rawValue ? filter.color : Color("InactiveFilterColor")))
        .clipShape(.rect(cornerRadius: 18, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.background)
                .padding(activeFilter == "All Patterns" && filter.rawValue != "All Patterns" ? -3 : 3)
        }
        .onTapGesture {
            guard filter != .allPatterns else { return }
            withAnimation(.bouncy) {
                activeFilter == filter.rawValue ? activeFilter = "All Patterns" : (activeFilter = filter.rawValue)
            }
        }
    }
}
