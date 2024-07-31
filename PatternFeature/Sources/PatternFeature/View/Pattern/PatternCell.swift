import SwiftUI

struct PatternCell: View {
    let pattern: PatternDTO
    let isExpanded: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            PatternStickChart(pattern: pattern)
                .background(backgroundColor)
                .cornerRadius(30)
                .shadow(color: shadowColor, radius: 7)

            Text(pattern.name)
                .font(.subheadline.bold())
                .lineLimit(1)
                .padding(.top, 10)

            if isExpanded {
                Text(pattern.info)
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 350)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(overlayColor)
        )
        .animation(.easeInOut(duration: 0.5), value: isExpanded)
        .onTapGesture(perform: onTap)
    }

    private var overlayColor: Color {
        isExpanded ? (colorScheme == .dark ? .white.opacity(0.15) : .black.opacity(0.1)) : .clear
    }

    private var shadowColor: Color {
        (colorScheme == .dark ? Color.white : .black).opacity(isExpanded ? 0.4 : 0.15)
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
}
