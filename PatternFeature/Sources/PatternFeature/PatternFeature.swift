import DI
import Factory
import SwiftUICore

public struct PatternFeature: View {
    @Injected(\.fetchPatternsUseCase) private var fetchPatternsUseCase

    public init() {}

    public var body: some View {
        PatternView(
            model: PatternModel(
                fetchPatternsUseCase: fetchPatternsUseCase
            )
        )
    }
}
