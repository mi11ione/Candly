import CoreDI
import SwiftUI

public struct PatternFeature: View {
    @Environment(\.diContainer) private var diContainer

    public init() {}

    public var body: some View {
        PatternView(model: PatternModel(repository: diContainer.resolve()))
    }
}
