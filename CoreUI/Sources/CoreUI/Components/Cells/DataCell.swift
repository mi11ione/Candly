import SwiftUI

public struct DataCell<Content: View, Footer: View, ExpandedContent: View>: View {
    @Binding private var isExpanded: Bool
    private let content: () -> Content
    private let footer: () -> Footer
    private let expandedContent: () -> ExpandedContent

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
                .cellBackground(isExpanded: isExpanded)

            footer()

            if isExpanded {
                expandedContent()
            }
        }
        .cellOverlay(isExpanded: isExpanded)
        .animation(.spring(), value: isExpanded)
    }
}
