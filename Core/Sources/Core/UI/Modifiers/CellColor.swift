import SwiftUICore

struct CellColor: ViewModifier {
    let isExpanded: Bool
    let isContent: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(backgroundColor)
                    )
            )
    }

    private var backgroundColor: Color {
        #if os(visionOS)
            if isContent {
                return Color.white.opacity(0.05)
            } else {
                return isExpanded ? Color.white.opacity(0.1) : .clear
            }
        #else
            return isExpanded ? Color("CellColor") : .clear
        #endif
    }
}
