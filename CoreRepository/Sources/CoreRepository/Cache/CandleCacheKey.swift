import SharedModels

public struct CandleCacheKey: Hashable, Sendable {
    let ticker: String
    let time: ChartTime
}
