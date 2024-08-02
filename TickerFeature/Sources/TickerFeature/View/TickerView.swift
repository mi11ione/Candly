import CoreDI
import CoreUI
import RepositoryInterfaces
import SwiftUI

struct TickerView: View {
    @Environment(\.diContainer) private var container: DIContainer
    @StateObject private var tickerContainer = TickerContainer()

    var body: some View {
        NavigationStack {
            Group {
                if tickerContainer.state.isLoading {
                    ProgressView()
                } else if let error = tickerContainer.state.error {
                    ErrorView(error: error) {
                        Task {
                            await tickerContainer.dispatch(.loadTickers)
                        }
                    }
                } else {
                    tickerList
                }
            }
            .navigationTitle("Tickers")
            .searchable(text: Binding(
                get: { tickerContainer.state.searchText },
                set: { newValue in
                    Task {
                        await tickerContainer.dispatch(.updateSearchText(newValue))
                    }
                }
            ), prompt: "Search tickers")
        }
        .task {
            if !tickerContainer.hasLoadedData {
                await setupContainer()
            }
        }
    }

    private var tickerList: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                ForEach(tickerContainer.state.tickers) { ticker in
                    TickerCell(ticker: ticker)
                }
            }
            .padding()
        }
    }

    private func setupContainer() async {
        let repository: TickerRepositoryProtocol = await container.resolve()
        tickerContainer.setRepository(repository)
        await tickerContainer.dispatch(.loadTickers)
    }
}
