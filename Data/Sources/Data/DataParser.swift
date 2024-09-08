import Foundation
import SharedModels

public struct DataParser {
    public let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func parsePatterns(from data: Data) throws -> [Pattern] {
        let patterns = try decoder.decode([Pattern].self, from: data)
        guard !patterns.isEmpty else {
            throw DataParserError.emptyResult
        }
        return patterns
    }

    public func parseTickers(from data: Data) throws -> [Ticker] {
        let moexTickers = try decoder.decode(MoexTickers.self, from: data)
        let parsedTickers = moexTickers.securities.data.compactMap { tickerData -> Ticker? in
            guard tickerData.count >= 26,
                  case let .string(title) = tickerData[0],
                  case let .string(subTitle) = tickerData[2],
                  case let .double(price) = tickerData[3],
                  case let .double(priceChange) = tickerData[25]
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

        guard !parsedTickers.isEmpty else {
            throw DataParserError.emptyResult
        }

        return parsedTickers
    }

    public func parseCandles(from data: Data, ticker: String) throws -> [Candle] {
        let moexCandles = try decoder.decode(MoexCandles.self, from: data)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let parsedCandles = moexCandles.candles.data.compactMap { candleData -> Candle? in
            guard
                case let .string(dateString) = candleData[6],
                let date = dateFormatter.date(from: dateString),
                case let .double(openPrice) = candleData[0],
                case let .double(closePrice) = candleData[1],
                case let .double(highPrice) = candleData[2],
                case let .double(lowPrice) = candleData[3]
            else { return nil }

            return Candle(
                id: UUID(),
                date: date,
                openPrice: openPrice,
                closePrice: closePrice,
                highPrice: highPrice,
                lowPrice: lowPrice,
                ticker: ticker
            )
        }

        guard !parsedCandles.isEmpty else {
            throw DataParserError.emptyResult
        }

        return parsedCandles
    }
}

public enum DataParserError: Error {
    case emptyResult
}
