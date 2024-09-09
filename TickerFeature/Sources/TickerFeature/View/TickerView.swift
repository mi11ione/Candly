import CoreArchitecture
import SharedModels
import SwiftUI

public struct TickerView: BaseView {
    public typealias T = Ticker
    public typealias I = TickerIntent
    @State public var model: TickerModel

    public var body: some View {
        NavigationStack {
            ZStack {
                if model.isLoading {
                    ProgressView()
                } else if let error = model.error {
                    TickerError(message: error) {
                        handleIntent(.loadTickers)
                    }
                } else {
                    TickerGrid(tickers: model.filteredItems)
                }
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
