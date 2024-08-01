import Foundation
import SharedModels

struct TickerState {
    var tickers: [SharedModels.TickerDTO] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var error: String?
}
