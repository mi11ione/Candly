import Foundation

enum TickerIntent {
    case loadTickers
    case updateSearchText(String)
    case dismissError
}
