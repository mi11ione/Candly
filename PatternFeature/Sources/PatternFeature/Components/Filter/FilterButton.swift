import SwiftUI

struct FilterButton: View {
    var filter: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
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
        #if os(iOS)
            .sensoryFeedback(.impact, trigger: isSelected)
        #endif
    }
}
