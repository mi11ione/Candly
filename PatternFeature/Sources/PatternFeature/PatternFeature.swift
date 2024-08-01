import CoreRepository
import SwiftUI

public struct PatternFeature: View {
    private let repository: PatternRepository

    public init(repository: PatternRepository) {
        self.repository = repository
    }

    public var body: some View {
        PatternView(repository: repository)
    }
}
