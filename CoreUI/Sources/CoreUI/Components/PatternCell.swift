import SharedModels
import SwiftUI

public struct PatternCell: View {
    let pattern: PatternDTO
    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme

    public init(pattern: PatternDTO) {
        self.pattern = pattern
    }

    public var body: some View {
        VStack {
            PatternStickChart(pattern: pattern)
                .background(backgroundColor)
                .cornerRadius(30)
                .shadow(color: shadowColor, radius: 7, x: 0, y: 0)

            Text(pattern.name)
                .font(.callout)
                .bold()
                .padding(.top, 4)

            if isExpanded {
                Text(pattern.info)
                    .font(.footnote)
                    .padding()
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
