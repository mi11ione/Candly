import Foundation

public enum TickerIntent: Equatable {
    case loadTickers
    case updateSearchText(String)
    case toggleTickerExpansion(UUID)
}
