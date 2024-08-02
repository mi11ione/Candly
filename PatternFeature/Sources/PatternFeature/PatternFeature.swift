import RepositoryInterfaces
import SwiftUI

public struct PatternFeature: View {
    private let repository: PatternRepositoryProtocol

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
    }

    public var body: some View {
        PatternView(repository: repository)
    }
}
