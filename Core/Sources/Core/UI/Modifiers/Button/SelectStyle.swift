import SwiftUICore

struct SelectButtonStyle: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(isSelected ? Color("InvertedTextColor") : .primary)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(isSelected ? .primary : Color("BackgroundColor"))
            .cornerRadius(16)
            .shadow(color: Color("ShadowColor"), radius: 6)
    }
}
