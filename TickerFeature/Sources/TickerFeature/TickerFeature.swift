import CoreDI
import SwiftUI

public struct TickerFeature: View {
    @Environment(\.dependencyFactory) private var dependencyFactory

    public init() {}

    public var body: some View {
        TickerView(model: TickerModel(repository: dependencyFactory.makeTickerRepository()))
    }
}
