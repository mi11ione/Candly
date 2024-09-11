import SwiftUI

struct CellBackgroundModifier: ViewModifier {
    let isExpanded: Bool

    func body(content: Content) -> some View {
        content
            .background(Color("BackgroundColor"))
            .cornerRadius(30)
            .shadow(color: Color(isExpanded ? "ShadowExpandedColor" : "ShadowColor"), radius: 6)
    }
}
