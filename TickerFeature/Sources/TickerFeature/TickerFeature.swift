import DI
import Factory
import SwiftUICore

public struct TickerFeature: View {
    @Injected(\.fetchTickersUseCase) private var fetchTickersUseCase

    public init() {}

    public var body: some View {
        TickerView(
            model: TickerModel(
                fetchTickersUseCase: fetchTickersUseCase
            )
        )
    }
}
