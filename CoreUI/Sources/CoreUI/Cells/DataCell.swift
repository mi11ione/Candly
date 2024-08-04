import SwiftUI

public struct DataCell<Content: View, Footer: View, ExpandedContent: View>: View {
    @Binding var isExpanded: Bool
    let content: () -> Content
    let footer: () -> Footer
    let expandedContent: () -> ExpandedContent

    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer,
        @ViewBuilder expandedContent: @escaping () -> ExpandedContent
    ) {
        _isExpanded = isExpanded
        self.content = content
        self.footer = footer
        self.expandedContent = expandedContent
    }

    public var body: some View {
        VStack {
            content()
                .background(Color("BackgroundColor"))
                .cornerRadius(30)
                .shadow(color: Color(isExpanded ? "ShadowExpandedColor" : "ShadowColor"), radius: 6)

            footer()

            if isExpanded {
                expandedContent()
            }
        }
        .frame(width: 350)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isExpanded ? Color("CellOverlayColor") : .clear)
                )
        )
        .animation(.spring(), value: isExpanded)
    }
}
