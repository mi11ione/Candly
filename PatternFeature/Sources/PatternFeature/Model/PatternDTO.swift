import Foundation

struct PatternDTO: Identifiable, Sendable {
    let id: UUID
    let name: String
    let info: String
    let filter: String
    let candles: [CandleDTO]
}

struct CandleDTO: Identifiable, Sendable {
    let id: UUID
    let date: Date
    let openPrice: Double
    let closePrice: Double
    let highPrice: Double
    let lowPrice: Double
}
