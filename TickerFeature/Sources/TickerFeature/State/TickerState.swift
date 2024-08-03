import Foundation
import SharedModels

struct TickerState {
    var tickers: [TickerDTO] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var error: String?
    var expandedTickerId: UUID?
}
