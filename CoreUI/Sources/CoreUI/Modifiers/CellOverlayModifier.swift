import SwiftUI

struct CellOverlayModifier: ViewModifier {
    let isExpanded: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(isExpanded ? Color("CellOverlayColor") : .clear)
                    )
            )
    }
}
