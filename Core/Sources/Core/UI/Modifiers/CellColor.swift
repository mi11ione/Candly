import SwiftUICore

struct CellColor: ViewModifier {
    let isExpanded: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                        #if os(visionOS)
                            .fill(Material.thin)
                        #else
                            .fill(isExpanded ? Color("CellColor") : .clear)
                        #endif
                    )
            )
    }
}
