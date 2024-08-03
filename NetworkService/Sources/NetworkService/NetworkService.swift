import ErrorHandling
import Foundation
import SharedModels

public protocol NetworkServiceProtocol: Sendable {
    func getMoexTickers() async throws -> [TickerDTO]
    func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO]
}

public actor NetworkService: NetworkServiceProtocol {
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

        let moexTickers: MoexTickers = try await performRequest(URLRequest(url: url))
        return parseMoexTickers(moexTickers)
    }

    public func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [CandleDTO] {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [timePeriod.queryItem]) else {
            throw NetworkError.invalidURL
        }

        let moexCandles: MoexCandles = try await performRequest(URLRequest(url: url))
        return parseMoexCandles(moexCandles)
    }

    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            return try decoder.decode(T.self, from: data)
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch let error as URLError {
            switch error.code {
            case .cannotFindHost:
                throw NetworkError.hostNotFound
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            default:
                throw NetworkError.requestFailed
            }
        }
    }

    private func parseMoexTickers(_ moexTickers: MoexTickers) -> [TickerDTO] {
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

    private func parseMoexCandles(_ moexCandles: MoexCandles) -> [CandleDTO] {
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
