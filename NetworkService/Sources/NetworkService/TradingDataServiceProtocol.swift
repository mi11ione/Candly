import Foundation
import SharedModels

public protocol TradingDataServiceProtocol: Sendable {
    func getMoexTickers() async throws -> [TickerDTO]
    func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO]
}

import Foundation
import SharedModels

public final class TradingDataService: TradingDataServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    public func getMoexTickers() async throws -> [TickerDTO] {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        let moexTickers = try decoder.decode(MoexTickers.self, from: data)
        return parseMoexTickers(moexTickers: moexTickers)
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
        moexTickers.securities.data.compactMap { tickerData in
            guard
                case let .string(title) = tickerData[0],
                case let .string(subTitle) = tickerData[2],
                case let .double(closePrice) = tickerData[11],
                case let .double(openPrice) = tickerData[6],
                openPrice != 0
            else { return nil }

            let priceChange = closePrice - openPrice
            return TickerDTO(
                id: UUID(),
                title: title,
                subTitle: subTitle,
                price: closePrice,
                priceChange: priceChange,
                currency: "RUB"
            )
        }
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
