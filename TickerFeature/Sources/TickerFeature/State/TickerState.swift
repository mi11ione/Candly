import Foundation
import SharedModels

struct TickerState: Equatable {
    var tickers: [TickerDTO] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var error: String?
    var expandedTickerId: UUID?
}
