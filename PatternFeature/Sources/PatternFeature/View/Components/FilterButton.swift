import SwiftUI

public struct FilterButton: View {
    private let filter: String
    private let isSelected: Bool
    private let action: () -> Void

    public init(filter: String, isSelected: Bool, action: @escaping () -> Void) {
        self.filter = filter
        self.isSelected = isSelected
        self.action = action
    }

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
