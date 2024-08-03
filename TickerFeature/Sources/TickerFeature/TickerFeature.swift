import CoreDI
import SwiftUI

public struct TickerFeature: View {
    @Environment(\.diContainer) private var diContainer

    public init() {}

    public var body: some View {
        TickerView(container: TickerContainer(repository: diContainer.resolve()))
    }
}
