import SwiftUI

struct FilterButton: View {
    let filter: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: { withAnimation { action() } }) {
            Text(filter)
                .font(.headline)
                .foregroundColor(isSelected ? invertedTextColor : .primary)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(isSelected ? .primary : backgroundColor)
                .cornerRadius(16)
                .shadow(color: shadowColor, radius: 5, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 2)
    }

    private var invertedTextColor: Color {
        colorScheme == .dark ? .black : .white
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    private var shadowColor: Color {
        (colorScheme == .dark ? Color.white : .black).opacity(0.1)
    }
}
