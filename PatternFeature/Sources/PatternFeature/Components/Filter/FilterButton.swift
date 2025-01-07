import SwiftUICore

struct FilterButton: View {
    @Binding var activeFilter: String
    let filter: FilterModel

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: filter.symbol)
                .opacity(activeFilter != filter.rawValue ? 1 : 0)
                .overlay(Image(systemName: filter.symbol).symbolVariant(.fill).opacity(activeFilter == filter.rawValue ? 1 : 0))

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
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.background)
                .padding(activeFilter == "All Patterns" && filter.rawValue != "All Patterns" ? -3 : 3)
        )
        .onTapGesture {
            guard filter != .allPatterns else { return }
            withAnimation(.bouncy) { activeFilter = (activeFilter == filter.rawValue) ? "All Patterns" : filter.rawValue }
        }
    }
}
