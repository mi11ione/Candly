import RepositoryInterfaces
import SwiftUI

struct TickerView: View {
    @StateObject private var container: TickerContainer

    init(repository: TickerRepositoryProtocol) {
        _container = StateObject(wrappedValue: TickerContainer(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if container.state.isLoading {
                    ProgressView()
                } else if let error = container.state.error {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                        Button("Try Again") {
                            container.dispatch(.loadTickers)
                        }
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
        .onAppear {
            if container.state.tickers.isEmpty {
                container.dispatch(.loadTickers)
            }
        }
    }

    private var tickerList: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                ForEach(container.state.tickers) { ticker in
                    TickerCell(ticker: ticker)
                }
            }
            .padding()
        }
    }
}
