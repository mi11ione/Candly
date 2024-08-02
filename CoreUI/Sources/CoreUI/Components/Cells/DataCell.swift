import SwiftUI

public struct DataCell<Content: View, Footer: View, ExpandedContent: View>: View {
    @Binding var isExpanded: Bool
    let content: () -> Content
    let footer: () -> Footer
    let expandedContent: () -> ExpandedContent

    @Environment(\.colorScheme) private var colorScheme

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
                .background(backgroundColor)
                .cornerRadius(30)
                .shadow(color: shadowColor, radius: 7)

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
                        .fill(overlayColor)
                )
        )
        .onTapGesture {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }
        .padding(.vertical, 6)
    }

    private var overlayColor: Color {
        isExpanded ? (colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)) : Color.clear
    }

    private var shadowColor: Color {
        isExpanded ? (colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.4)) : (colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.2))
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : .white
    }
}
