import Foundation
import SharedModels
import SwiftData

public actor PatternRepository: PatternRepositoryProtocol {
    public init() {}

    public func fetchPatterns(context: ModelContextProtocol) async throws -> [Pattern] {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    let descriptor = FetchDescriptor<Pattern>(sortBy: [SortDescriptor(\.name)])
                    let patterns = try context.fetch(descriptor)
                    if patterns.isEmpty {
                        let initialPatterns = try await self.createInitialPatterns(context: context)
                        continuation.resume(returning: initialPatterns)
                    } else {
                        continuation.resume(returning: patterns)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func createInitialPatterns(context: ModelContextProtocol) async throws -> [Pattern] {
        let patterns = [
            createPattern(name: "Three White Soldiers", info: "Bullish reversal pattern consisting of three consecutive long white candles.", filter: "Triple", dates: ["2016-04-14T10:00:00+0000", "2016-04-14T11:00:00+0000", "2016-04-14T12:00:00+0000"], opens: [108, 109, 121], closes: [120, 122, 130], highs: [122, 125, 130], lows: [107.5, 109, 121]),
            createPattern(name: "Inverted Hammer", info: "Bullish reversal pattern with a small body and a long upper shadow.", filter: "Single", dates: ["2016-04-21T10:00:00+0000"], opens: [100], closes: [102], highs: [107], lows: [99]),
            createPattern(name: "Doji", info: "Neutral pattern where opening and closing prices are nearly equal.", filter: "Single", dates: ["2016-04-25T10:00:00+0000"], opens: [105], closes: [105], highs: [110], lows: [100]),
            createPattern(name: "Closing Marubozu", info: "Bearish pattern with no lower shadow and a small or non-existent upper shadow.", filter: "Single", dates: ["2016-04-14T10:00:00+0000"], opens: [260], closes: [220], highs: [260], lows: [220]),
            createPattern(name: "Gartley Pattern", info: "Harmonic pattern used to identify potential reversal zones in price trends.", filter: "Complex", dates: ["2016-05-18T10:00:00+0000", "2016-05-18T11:00:00+0000", "2016-05-18T12:00:00+0000", "2016-05-18T13:00:00+0000", "2016-05-18T14:00:00+0000"], opens: [100, 105, 95, 100, 90], closes: [105, 95, 100, 90, 95], highs: [106, 106, 101, 101, 96], lows: [99, 94, 94, 89, 89]),
            createPattern(name: "Harami", info: "Reversal pattern where the second candle is completely contained within the first.", filter: "Double", dates: ["2016-04-14T10:00:00+0000", "2016-04-14T11:00:00+0000"], opens: [250, 210], closes: [200, 230], highs: [260, 235], lows: [195, 205]),
            createPattern(name: "Piercing Line", info: "Bullish reversal pattern where the second candle closes above the midpoint of the first.", filter: "Double", dates: ["2016-04-14T10:00:00+0000", "2016-04-14T11:00:00+0000"], opens: [250, 190], closes: [200, 240], highs: [255, 245], lows: [195, 185]),
            createPattern(name: "Shooting Star", info: "Bearish reversal pattern with a small body and a long upper shadow.", filter: "Single", dates: ["2016-04-15T10:00:00+0000"], opens: [100], closes: [98], highs: [110], lows: [97]),
            createPattern(name: "Morning Star", info: "Bullish reversal pattern consisting of three candles, signaling a potential uptrend.", filter: "Triple", dates: ["2016-04-16T10:00:00+0000", "2016-04-16T11:00:00+0000", "2016-04-16T12:00:00+0000"], opens: [100, 88, 92], closes: [90, 89, 98], highs: [102, 91, 100], lows: [88, 87, 91]),
            createPattern(name: "Evening Star", info: "Bearish reversal pattern consisting of three candles, signaling a potential downtrend.", filter: "Triple", dates: ["2016-04-17T10:00:00+0000", "2016-04-17T11:00:00+0000", "2016-04-17T12:00:00+0000"], opens: [100, 112, 108], closes: [110, 111, 102], highs: [112, 114, 109], lows: [99, 110, 100]),
            createPattern(name: "Three Black Crows", info: "Bearish reversal pattern consisting of three consecutive long black candles.", filter: "Triple", dates: ["2016-04-18T10:00:00+0000", "2016-04-18T11:00:00+0000", "2016-04-18T12:00:00+0000"], opens: [100, 94, 88], closes: [95, 89, 83], highs: [102, 95, 89], lows: [94, 88, 82]),
            createPattern(name: "Bullish Flag", info: "Continuation pattern showing a temporary pause in an uptrend before further gains.", filter: "Complex", dates: ["2016-04-19T10:00:00+0000", "2016-04-19T11:00:00+0000", "2016-04-19T12:00:00+0000", "2016-04-19T13:00:00+0000", "2016-04-19T14:00:00+0000"], opens: [100, 111, 110, 109, 108], closes: [110, 109, 108, 107, 115], highs: [112, 113, 111, 110, 117], lows: [99, 108, 107, 106, 107]),
            createPattern(name: "Bullish Engulfing", info: "Bullish reversal pattern where the second candle completely engulfs the first.", filter: "Double", dates: ["2016-04-20T10:00:00+0000", "2016-04-20T11:00:00+0000"], opens: [100, 94], closes: [95, 103], highs: [102, 104], lows: [94, 93]),
            createPattern(name: "Bearish Engulfing", info: "Bearish reversal pattern is a reversed Bullish Engulfing.", filter: "Double", dates: ["2016-04-21T10:00:00+0000", "2016-04-21T11:00:00+0000"], opens: [100, 106], closes: [105, 98], highs: [106, 107], lows: [99, 97]),
            createPattern(name: "Tweezer Top", info: "Bearish reversal pattern with two candles having the same high price.", filter: "Double", dates: ["2016-04-22T10:00:00+0000", "2016-04-22T11:00:00+0000"], opens: [100, 105], closes: [105, 101], highs: [107, 107], lows: [99, 100]),
            createPattern(name: "Head and Shoulders", info: "Bearish reversal pattern resembling a head with two shoulders, signaling a potential downtrend.", filter: "Complex", dates: ["2016-04-23T10:00:00+0000", "2016-04-23T11:00:00+0000", "2016-04-23T12:00:00+0000", "2016-04-23T13:00:00+0000", "2016-04-23T14:00:00+0000"], opens: [100, 106, 110, 108, 115], closes: [105, 110, 108, 115, 105], highs: [106, 112, 111, 116, 116], lows: [99, 105, 107, 107, 104]),
            createPattern(name: "Cup and Handle", info: "Bullish continuation pattern resembling a cup with a handle, indicating a potential upward breakout.", filter: "Complex", dates: ["2016-04-24T10:00:00+0000", "2016-04-24T11:00:00+0000", "2016-04-24T12:00:00+0000", "2016-04-24T13:00:00+0000", "2016-04-24T14:00:00+0000"], opens: [100, 95, 98, 100, 99], closes: [95, 98, 100, 99, 103], highs: [102, 99, 101, 101, 104], lows: [94, 94, 97, 98, 98]),
            createPattern(name: "Rising Wedge", info: "Bearish reversal pattern with converging trendlines, both sloping upward, indicating a potential downward breakout.", filter: "Complex", dates: ["2016-04-25T10:00:00+0000", "2016-04-25T11:00:00+0000", "2016-04-25T12:00:00+0000", "2016-04-25T13:00:00+0000", "2016-04-25T14:00:00+0000"], opens: [100, 102, 104, 105, 106], closes: [102, 104, 105, 106, 104], highs: [103, 105, 106, 107, 107], lows: [99, 101, 103, 104, 103]),
        ]

        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                do {
                    for pattern in patterns {
                        context.insert(pattern)
                    }
                    try context.save()
                    continuation.resume(returning: patterns)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func createPattern(name: String, info: String, filter: String, dates: [String], opens: [Double], closes: [Double], highs: [Double], lows: [Double]) -> Pattern {
        let candles = zip(dates, zip(opens, zip(closes, zip(highs, lows)))).map { date, values in
            Candle(id: UUID(), date: Candle.from(dateString: date), openPrice: values.0, closePrice: values.1.0, highPrice: values.1.1.0, lowPrice: values.1.1.1, ticker: "PATTERN_\(name)")
        }
        return Pattern(id: UUID(), name: name, info: info, filter: filter, candles: candles)
    }
}
