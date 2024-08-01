import Foundation
import SharedModels

public protocol NetworkServiceProtocol: Sendable {
    func fetchMoexTickers() async throws -> [TickerDTO]
    func fetchMoexCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO]
}

public final class NetworkService: NetworkServiceProtocol, @unchecked Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    public func fetchMoexTickers() async throws -> [TickerDTO] {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw NetworkError.invalidURL
        }

        let moexTickers: MoexTickers = try await performRequest(URLRequest(url: url))
        return parseMoexTickers(moexTickers)
    }

    public func fetchMoexCandles(for ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO] {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [timePeriod.queryItem]) else {
            throw NetworkError.invalidURL
        }

        let moexCandles: MoexCandles = try await performRequest(URLRequest(url: url))
        return parseMoexCandles(moexCandles)
    }

    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            return try decoder.decode(T.self, from: data)
        } catch let error as NSError {
            if error.domain == NSURLErrorDomain, error.code == NSURLErrorCannotFindHost {
                throw NetworkError.hostNotFound
            }
            throw error
        }
    }

    private func parseMoexTickers(_ moexTickers: MoexTickers) -> [TickerDTO] {
        moexTickers.securities.data.compactMap { tickerData in
            guard
                case let .string(title) = tickerData[0],
                case let .string(subTitle) = tickerData[2],
                case let .double(price) = tickerData[3],
                case let .double(priceChange) = tickerData[25]
            else { return nil }

            return TickerDTO(
                title: title,
                subTitle: subTitle,
                price: price,
                priceChange: priceChange,
                currency: "RUB"
            )
        }
    }

    private func parseMoexCandles(_ moexCandles: MoexCandles) -> [CandleDTO] {
        moexCandles.candles.data.compactMap { candleData in
            guard
                case let .double(open) = candleData[0],
                case let .double(close) = candleData[1],
                case let .double(high) = candleData[2],
                case let .double(low) = candleData[3],
                case let .string(dateString) = candleData[6],
                let date = ISO8601DateFormatter().date(from: dateString)
            else { return nil }

            return CandleDTO(
                id: UUID(),
                date: date,
                openPrice: open,
                closePrice: close,
                highPrice: high,
                lowPrice: low
            )
        }
    }
}
