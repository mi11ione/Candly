import SwiftUI

public struct SelectButton<Label: View>: View {
    private let isSelected: Bool
    private let action: () -> Void
    private let label: () -> Label

    public init(
        isSelected: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.isSelected = isSelected
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: { withAnimation { action() } }) {
            label()
                .selectButtonStyle(isSelected: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        #if os(iOS)
            .sensoryFeedback(.impact, trigger: isSelected)
        #endif
    }
}
