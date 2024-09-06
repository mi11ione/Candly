import Foundation
import SharedModels

public struct CandleCacheKey: Hashable, Sendable {
    let ticker: String
    let timePeriod: ChartTimePeriod
}
