import SwiftUI

public struct FilterButton: View {
    public var filter: String
    public var isSelected: Bool
    public var action: () -> Void

    public var body: some View {
        Button(action: { withAnimation { action() } }) {
            Text(filter)
                .font(.headline)
                .foregroundColor(isSelected ? Color("InvertedTextColor") : .primary)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(isSelected ? .primary : Color("BackgroundColor"))
                .cornerRadius(16)
                .shadow(color: Color("ShadowColor"), radius: 6)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 2)
    }
}
