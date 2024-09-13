import SwiftUICore

extension View {
    func cellBackground(isExpanded: Bool) -> some View {
        modifier(CellBackground(isExpanded: isExpanded))
    }

    func cellColor(isExpanded: Bool) -> some View {
        modifier(CellColor(isExpanded: isExpanded))
    }
}
