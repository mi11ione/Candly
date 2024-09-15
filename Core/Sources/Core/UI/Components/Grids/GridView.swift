import SwiftUI

public struct GridView<T: Identifiable, Content: View>: View {
    private let items: [T]
    private let content: (T) -> Content

    public init(
        items: [T],
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.items = items
        self.content = content
    }

    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 25)], spacing: 20) {
            ForEach(items) { item in
                content(item)
            }
        }
        .padding()
    }
}
