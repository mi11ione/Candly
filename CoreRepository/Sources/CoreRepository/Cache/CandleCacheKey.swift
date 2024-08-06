import Foundation
import NetworkService

public struct CandleCacheKey: Hashable, Sendable {
    let ticker: String
    let timePeriod: ChartTimePeriod
}
