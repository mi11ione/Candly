import DI
import Domain
import Factory
import SwiftUI

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
