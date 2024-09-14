import Foundation
import Models

public struct DataParser {
    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func parsePatterns(from data: Data) throws -> [Pattern] {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        guard let patternsData = json else {
            throw DataParserError.invalidData
        }

        return patternsData.compactMap { patternData -> Pattern? in
            guard let name = patternData["name"] as? String,
                  let info = patternData["info"] as? String,
                  let filter = patternData["filter"] as? String,
                  let candlesData = patternData["candles"] as? [[String: Any]]
            else { return nil }

            let candles = candlesData.compactMap { candleData -> Candle? in
                guard let dateString = candleData["date"] as? String,
                      let date = ISO8601DateFormatter().date(from: dateString),
                      let openPrice = candleData["openPrice"] as? Double,
                      let closePrice = candleData["closePrice"] as? Double,
                      let highPrice = candleData["highPrice"] as? Double,
                      let lowPrice = candleData["lowPrice"] as? Double,
                      let ticker = candleData["ticker"] as? String
                else { return nil }

                let value = candleData["value"] as? Double ?? 0
                let volume = candleData["volume"] as? Double ?? 0
                let endDate = (candleData["endDate"] as? String).flatMap { ISO8601DateFormatter().date(from: $0) } ?? date

                return Candle(
                    id: UUID(),
                    date: date,
                    openPrice: openPrice,
                    closePrice: closePrice,
                    highPrice: highPrice,
                    lowPrice: lowPrice,
                    value: value,
                    volume: volume,
                    endDate: endDate,
                    ticker: ticker
                )
            }

            return Pattern(
                id: UUID(),
                name: name,
                info: info,
                filter: filter,
                candles: candles
            )
        }
    }

    public func parseTickers(from data: Data) throws -> [Ticker] {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let securitiesData = json?["securities"] as? [String: Any],
              let tickersData = securitiesData["data"] as? [[Any]]
        else {
            throw DataParserError.invalidData
        }

        return tickersData.compactMap { tickerData -> Ticker? in
            guard tickerData.count >= 26,
                  let title = tickerData[0] as? String,
                  let subTitle = tickerData[2] as? String,
                  let price = tickerData[3] as? Double,
                  let priceChange = tickerData[25] as? Double
            else { return nil }

            return Ticker(
                id: UUID(),
                title: title,
                subTitle: subTitle,
                price: price,
                priceChange: priceChange,
                currency: "RUB"
            )
        }
    }

    public func parseCandles(from data: Data, ticker: String) throws -> [Candle] {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let candlesData = json?["candles"] as? [String: Any],
              let candlesList = candlesData["data"] as? [[Any]]
        else {
            throw DataParserError.invalidData
        }

        return candlesList.compactMap { candleData -> Candle? in
            guard candleData.count >= 8,
                  let openPrice = candleData[0] as? Double,
                  let closePrice = candleData[1] as? Double,
                  let highPrice = candleData[2] as? Double,
                  let lowPrice = candleData[3] as? Double,
                  let value = candleData[4] as? Double,
                  let volume = candleData[5] as? Double,
                  let beginString = candleData[6] as? String,
                  let endString = candleData[7] as? String,
                  let beginDate = DateFormatter.moexDateFormatter.date(from: beginString),
                  let endDate = DateFormatter.moexDateFormatter.date(from: endString)
            else { return nil }

            return Candle(
                id: UUID(),
                date: beginDate,
                openPrice: openPrice,
                closePrice: closePrice,
                highPrice: highPrice,
                lowPrice: lowPrice,
                value: value,
                volume: volume,
                endDate: endDate,
                ticker: ticker
            )
        }
    }
}

enum DataParserError: Error {
    case invalidData
}

extension DateFormatter {
    static let moexDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()
}
