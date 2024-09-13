import SwiftUICore

public struct CellView<Content: View, Footer: View, ExpandedContent: View>: View {
    @State private var isExpanded: Bool = false
    private let content: () -> Content
    private let footer: () -> Footer
    private let expandedContent: () -> ExpandedContent

    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer,
        @ViewBuilder expandedContent: @escaping () -> ExpandedContent
    ) {
        self.content = content
        self.footer = footer
        self.expandedContent = expandedContent
    }

    public var body: some View {
        VStack {
            content()
                .cellBackground(isExpanded: isExpanded)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }
            #if os(iOS)
                .sensoryFeedback(.impact, trigger: isExpanded)
            #endif

            footer()

            if isExpanded {
                expandedContent()
            }
        }
        .cellOverlay(isExpanded: isExpanded)
    }
}
