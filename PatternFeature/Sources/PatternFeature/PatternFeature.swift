import CoreDI
import SwiftUI

public struct PatternFeature: View {
    @Environment(\.dependencyFactory) private var dependencyFactory

    public init() {}

    public var body: some View {
        PatternView(
            model: PatternModel(
                fetchPatternsUseCase: dependencyFactory.makeFetchPatternsUseCase()
            )
        )
    }
}
