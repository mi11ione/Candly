import SwiftUICore

extension View {
    func cellBackground(isExpanded: Bool) -> some View {
        modifier(CellBackground(isExpanded: isExpanded))
    }

    func cellColor(isExpanded: Bool, isContent: Bool = false) -> some View {
        modifier(CellColor(isExpanded: isExpanded, isContent: isContent))
    }

    func selectButtonStyle(isSelected: Bool) -> some View {
        modifier(SelectButtonStyle(isSelected: isSelected))
    }
}
