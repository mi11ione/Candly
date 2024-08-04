import CoreUI
import ErrorHandling
import SwiftUI

public struct TickerView: View {
    @State private var model: TickerModel

    public init(model: TickerModel) {
        _model = State(initialValue: model)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                if model.isLoading {
                    ProgressView()
                } else if let error = model.error {
                    ErrorView(error: error) {
                        model.load()
                    }
                } else {
                    TickerGrid(
                        tickers: model.filteredItems,
                        expandedTickerId: model.expandedItemId,
                        onTickerTapped: { model.toggleItemExpansion($0) }
                    )
                }
            }
            .navigationTitle("Tickers")
            .searchable(text: .init(
                get: { model.searchText },
                set: { model.updateSearchText($0) }
            ), prompt: "Search tickers")
        }
        .onAppear { model.load() }
    }
}
