import SwiftUICore

struct CellBackground: ViewModifier {
    let isExpanded: Bool

    func body(content: Content) -> some View {
        content
        #if os(visionOS) || os(tvOS)
        .background(Material.ultraThin)
        #else
        .background(Color("BackgroundColor"))
        #endif
        .cornerRadius(30)
        .shadow(color: Color(isExpanded ? "ShadowExpandedColor" : "ShadowColor"), radius: 6)
    }
}
