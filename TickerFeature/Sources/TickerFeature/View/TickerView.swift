import RepositoryInterfaces
import SharedModels
import SwiftUI

struct TickerView: View {
    @StateObject private var container: TickerContainer

    init(repository: TickerRepositoryProtocol) {
        _container = StateObject(wrappedValue: TickerContainer(repository: repository))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                    ForEach(container.state.tickers) { ticker in
                        TickerCell(ticker: ticker)
                    }
                }
                .padding()
            }
            .navigationTitle("Tickers")
            .searchable(text: Binding(
                get: { container.state.searchText },
                set: { container.dispatch(.updateSearchText($0)) }
            ), prompt: "Search tickers")
        }
        .onAppear { container.dispatch(.loadTickers) }
    }
}
