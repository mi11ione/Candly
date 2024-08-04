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
                    tickerList
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

    private var tickerList: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                ForEach(model.filteredTickers) { ticker in
                    TickerCell(
                        ticker: ticker,
                        isExpanded: model.state.expandedTickerId == ticker.id,
                        onTap: { model.process(.toggleTickerExpansion(ticker.id)) }
                    )
                }
            }
            .padding()
            .animation(.spring, value: model.state.expandedTickerId)
        }
    }
}
