import Core
import Models
import SwiftUI

struct TickerView: BaseView {
    typealias T = Ticker
    typealias I = TickerIntent
    @State var model: TickerModel

    var body: some View {
        NavigationStack {
            ScrollView {
                TickerGrid(
                    tickers: model.filteredItems,
                    candles: model,
                    isLoading: model.isLoading,
                    error: model.error,
                    retryAction: { handleIntent(.loadTickers) }
                )
            }
            .navigationTitle("Tickers")
            .searchable(text: .init(
                get: { model.searchText },
                set: { handleIntent(.updateSearchText($0)) }
            ), prompt: "Search tickers")
        }
        .onAppear { handleIntent(.loadTickers) }
        .animation(.spring, value: model.filteredItems)
    }
}
