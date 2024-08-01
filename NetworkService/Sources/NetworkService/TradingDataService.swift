import Foundation
import SharedModels

public protocol TradingDataServiceProtocol: Sendable {
    func getMoexTickers() async throws -> [TickerDTO]
    func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO]
}

public final class TradingDataService: TradingDataServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        session = URLSession(configuration: configuration)
        decoder = JSONDecoder()
    }

    public func getMoexTickers() async throws -> [TickerDTO] {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            let moexTickers = try decoder.decode(MoexTickers.self, from: data)
            print("Decoded MoexTickers: \(moexTickers)")

            let parsedTickers = parseMoexTickers(moexTickers: moexTickers)
            print("Parsed \(parsedTickers.count) tickers")

            for ticker in parsedTickers {
                print("Ticker: \(ticker.title), Price: \(ticker.price), Change: \(ticker.priceChange)")
            }

            return parsedTickers
        } catch {
            print("Network error: \(error)")
            throw error
        }
    }

    public func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO] {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [timePeriod.queryItem]) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        let moexCandles = try decoder.decode(MoexCandles.self, from: data)
        return parseMoexCandles(moexCandles: moexCandles)
    }

    private func parseMoexTickers(moexTickers: MoexTickers) -> [TickerDTO] {
        let parsedTickers = moexTickers.securities.data.compactMap { tickerData -> TickerDTO? in
            guard tickerData.count >= 26 else {
                print("Ticker data has insufficient elements: \(tickerData)")
                return nil
            }

            guard case let .string(title) = tickerData[0],
                  case let .string(subTitle) = tickerData[2],
                  case let .double(price) = tickerData[3],
                  case let .double(priceChange) = tickerData[25]
            else {
                print("Invalid ticker data types: \(tickerData)")
                return nil
            }

            return TickerDTO(
                id: UUID(),
                title: title,
                subTitle: subTitle,
                price: price,
                priceChange: priceChange,
                currency: "RUB"
            )
        }

        print("Parsed \(parsedTickers.count) tickers")
        return parsedTickers
    }

    private func parseMoexCandles(moexCandles: MoexCandles) -> [CandleDTO] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return moexCandles.candles.data.compactMap { candleData in
            guard
                case let .string(dateString) = candleData[6],
                let date = dateFormatter.date(from: dateString),
                case let .double(openPrice) = candleData[0],
                case let .double(closePrice) = candleData[1],
                case let .double(highPrice) = candleData[2],
                case let .double(lowPrice) = candleData[3]
            else { return nil }

            return CandleDTO(
                id: UUID(),
                date: date,
                openPrice: openPrice,
                closePrice: closePrice,
                highPrice: highPrice,
                lowPrice: lowPrice
            )
        }
    }
}
