import SwiftUICore

struct CellColor: ViewModifier {
    let isExpanded: Bool
    let isContent: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(backgroundColor)
            )
    }

    private var backgroundColor: Color {
        #if os(visionOS)
            .white.opacity(isContent ? 0.05 : (isExpanded ? 0.1 : 0))
        #else
            isExpanded ? Color("CellColor") : .clear
        #endif
    }
}
