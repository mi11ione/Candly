import SwiftUICore

extension View {
    func cellBackground(isExpanded: Bool) -> some View {
        modifier(CellBackgroundModifier(isExpanded: isExpanded))
    }

    func cellOverlay(isExpanded: Bool) -> some View {
        modifier(CellOverlayModifier(isExpanded: isExpanded))
    }
}
