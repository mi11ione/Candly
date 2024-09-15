import Foundation
import Models

public actor DataService {
    public init() {}

    private func parseDate(_ dateString: String, isPattern: Bool) -> Date? {
        isPattern ? ISO8601DateFormatter().date(from: dateString) : DateFormatter.moexDateFormatter.date(from: dateString)
    }

    public func parseCandle(from data: [String: Any], isPattern: Bool) -> Candle? {
        guard let openPrice = data["openPrice"] as? Double,
              let closePrice = data["closePrice"] as? Double,
              let highPrice = data["highPrice"] as? Double,
              let lowPrice = data["lowPrice"] as? Double,
              let value = data["value"] as? Double,
              let volume = data["volume"] as? Double,
              let dateString = data["date"] as? String,
              let date = parseDate(dateString, isPattern: isPattern)
        else { return nil }

        let endDate = (data["endDate"] as? String).flatMap { parseDate($0, isPattern: isPattern) }
        let ticker = data["ticker"] as? String ?? ""

        return Candle(
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

    public func parsePatterns(from data: Data) throws -> [Pattern] {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            throw URLError(.cannotParseResponse)
        }

        return json.compactMap { patternData -> Pattern? in
            guard let name = patternData["name"] as? String,
                  let info = patternData["info"] as? String,
                  let filter = patternData["filter"] as? String,
                  let candlesData = patternData["candles"] as? [[String: Any]]
            else { return nil }

            let candles = candlesData.compactMap { parseCandle(from: $0, isPattern: true) }

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
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let securitiesData = json["securities"] as? [String: Any],
              let tickersData = securitiesData["data"] as? [[Any]]
        else {
            throw URLError(.cannotParseResponse)
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
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let candlesData = json["candles"] as? [String: Any],
              let candlesList = candlesData["data"] as? [[Any]]
        else {
            throw URLError(.cannotParseResponse)
        }

        return candlesList.compactMap { candleData -> Candle? in
            guard candleData.count >= 8 else { return nil }

            let candleDict: [String: Any] = [
                "openPrice": candleData[0],
                "closePrice": candleData[1],
                "highPrice": candleData[2],
                "lowPrice": candleData[3],
                "value": candleData[4],
                "volume": candleData[5],
                "date": candleData[6],
                "endDate": candleData[7],
                "ticker": ticker,
            ]

            return parseCandle(from: candleDict, isPattern: false)
        }
    }
}
