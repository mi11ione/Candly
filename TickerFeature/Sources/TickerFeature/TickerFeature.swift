import RepositoryInterfaces
import SwiftUI

public struct TickerFeature: View {
    private let repository: TickerRepositoryProtocol

    public init(repository: TickerRepositoryProtocol) {
        self.repository = repository
    }

    public var body: some View {
        TickerView(repository: repository)
    }
}
