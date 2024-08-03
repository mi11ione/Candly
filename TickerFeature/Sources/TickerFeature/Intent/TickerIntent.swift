import Foundation

enum TickerIntent: Equatable {
    case loadTickers
    case updateSearchText(String)
    case toggleTickerExpansion(UUID)
}
