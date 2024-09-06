import SwiftUI

public struct GridView<T: Identifiable, Content: View>: View {
    private let items: [T]
    private let expandedItemId: T.ID?
    private let onItemTapped: (T.ID) -> Void
    private let content: (T, Bool) -> Content

    public init(
        items: [T],
        expandedItemId: T.ID?,
        onItemTapped: @escaping (T.ID) -> Void,
        @ViewBuilder content: @escaping (T, Bool) -> Content
    ) {
        self.items = items
        self.expandedItemId = expandedItemId
        self.onItemTapped = onItemTapped
        self.content = content
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 25)], spacing: 20) {
                ForEach(items) { item in
                    content(item, expandedItemId == item.id)
                        .onTapGesture { onItemTapped(item.id) }
                }
            }
            .padding()
            .animation(.spring, value: expandedItemId)
        }
    }
}
