import SharedModels

public struct CandleCacheKey: Hashable, Sendable {
    private let ticker: String
    private let time: ChartTime

    public init(ticker: String, time: ChartTime) {
        self.ticker = ticker
        self.time = time
    }
}
