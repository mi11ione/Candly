import CoreUI
import SwiftUI

struct TickerView: View {
    @StateObject private var container: TickerContainer

    init(container: @autoclosure @escaping () -> TickerContainer) {
        _container = StateObject(wrappedValue: container())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if container.state.isLoading {
                    ProgressView()
                } else if let error = container.state.error {
                    ErrorView(error: error) {
                        container.dispatch(.loadTickers)
                    }
                } else {
                    tickerList
                }
            }
            .navigationTitle("Tickers")
            .searchable(text: Binding(
                get: { container.state.searchText },
                set: { container.dispatch(.updateSearchText($0)) }
            ), prompt: "Search tickers")
        }
        .onAppear { container.dispatch(.loadTickers) }
    }

    private var tickerList: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                ForEach(container.filteredTickers) { ticker in
                    TickerCell(
                        ticker: ticker,
                        isExpanded: container.state.expandedTickerId == ticker.id,
                        onTap: { container.dispatch(.toggleTickerExpansion(ticker.id)) }
                    )
                }
            }
            .padding()
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: container.state.expandedTickerId)
        }
    }
}
