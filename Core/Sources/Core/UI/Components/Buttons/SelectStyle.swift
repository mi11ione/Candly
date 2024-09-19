import SwiftUICore

struct SelectButtonStyle: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(foregroundColor)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(color: Color("ShadowColor"), radius: 6)
    }

    private var foregroundColor: Color {
        #if os(visionOS) || os(tvOS)
            isSelected ? .black : .white
        #else
            isSelected ? Color("InvertedTextColor") : .primary
        #endif
    }

    private var backgroundColor: Color {
        #if os(visionOS) || os(tvOS)
            .white.opacity(isSelected ? 1 : 0.2)
        #else
            isSelected ? .primary : Color("BackgroundColor")
        #endif
    }
}
