import CoreUI
import ErrorHandling
import SwiftUI

public struct TickerView: View {
    @StateObject var model: TickerModel

    public init(model: TickerModel) {
        _model = StateObject(wrappedValue: model)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                if model.state.isLoading {
                    ProgressView()
                } else if let error = model.state.error {
                    ErrorView(error: error) {
                        model.process(.loadTickers)
                    }
                } else {
                    TickerGridView(
                        tickers: model.filteredTickers,
                        expandedTickerId: model.state.expandedTickerId,
                        onTickerTapped: { model.process(.toggleTickerExpansion($0)) }
                    )
                }
            }
            .navigationTitle("Tickers")
            .searchable(text: Binding(
                get: { model.state.searchText },
                set: { model.process(.updateSearchText($0)) }
            ), prompt: "Search tickers")
        }
        .onAppear { model.process(.loadTickers) }
    }
}
