public enum TickerIntent: Equatable {
    case loadTickers
    case updateSearchText(String)
    case loadCandles([String])
}
