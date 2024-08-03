import SwiftUI

public struct FilterButton: View {
    public let filter: String
    public let isSelected: Bool
    public let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    public init(filter: String, isSelected: Bool, action: @escaping () -> Void) {
        self.filter = filter
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: { withAnimation { action() } }) {
            Text(filter)
                .font(.headline)
                .foregroundColor(isSelected ? invertedTextColor : .primary)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(isSelected ? .primary : backgroundColor)
                .cornerRadius(16)
                .shadow(color: shadowColor, radius: 6)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 2)
    }

    private var invertedTextColor: Color {
        colorScheme == .dark ? .black : .white
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : .white
    }

    private var shadowColor: Color {
        (colorScheme == .dark ? Color.white : .black).opacity(0.2)
    }
}
