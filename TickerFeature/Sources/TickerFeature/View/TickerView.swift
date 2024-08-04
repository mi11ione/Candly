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
            .searchable(text: $model.searchText, prompt: "Search tickers")
        }
        .onAppear { model.load() }
    }
}
