import Core
import Models
import SwiftUI

public struct TickerView: BaseView {
    public typealias T = Ticker
    public typealias I = TickerIntent
    @State public var model: TickerModel

    public var body: some View {
        NavigationStack {
            ScrollView {
                TickerGrid(
                    tickers: model.filteredItems,
                    isLoading: model.isLoading,
                    error: model.error
                ) { handleIntent(.loadTickers) }
            }
            .navigationTitle("Tickers")
            .searchable(text: .init(
                get: { model.searchText },
                set: { handleIntent(.updateSearchText($0)) }
            ), prompt: "Search tickers")
        }
        .onAppear { handleIntent(.loadTickers) }
    }
}
