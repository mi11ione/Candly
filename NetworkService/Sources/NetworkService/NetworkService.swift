import ErrorHandling
import Foundation
import SharedModels

public actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let errorHandler: ErrorHandling

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), errorHandler: ErrorHandling = DefaultErrorHandler()) {
        self.session = session
        self.decoder = decoder
        self.errorHandler = errorHandler
    }

    public func getMoexTickers() async throws -> [Ticker] {
        guard let url = MoexAPI.Endpoint.allTickers.url() else {
            throw errorHandler.handle(NetworkError.invalidURL)
        }

        let moexTickers: MoexTickers = try await performRequest(URLRequest(url: url))
        return try parseMoexTickers(moexTickers)
    }

    public func getMoexCandles(ticker: String, timePeriod: ChartTimePeriod) async throws -> [Candle] {
        guard let url = MoexAPI.Endpoint.candles(ticker).url(queryItems: [timePeriod.queryItem]) else {
            throw errorHandler.handle(NetworkError.invalidURL)
        }

        let moexCandles: MoexCandles = try await performRequest(URLRequest(url: url))
        return try parseMoexCandles(moexCandles, ticker: ticker)
    }

    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
                throw errorHandler.handle(NetworkError.invalidResponse)
            }
            return try decoder.decode(T.self, from: data)
        } catch is DecodingError {
            throw errorHandler.handle(NetworkError.decodingError)
        } catch let error as URLError {
            switch error.code {
            case .cannotFindHost:
                throw errorHandler.handle(NetworkError.hostNotFound)
            case .notConnectedToInternet:
                throw errorHandler.handle(NetworkError.noInternetConnection)
            default:
                throw errorHandler.handle(NetworkError.requestFailed)
            }
        }
    }

    private func parseMoexTickers(_ moexTickers: MoexTickers) throws -> [Ticker] {
        let parsedTickers = moexTickers.securities.data.compactMap { tickerData -> Ticker? in
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
            throw errorHandler.handle(NetworkError.decodingError)
        }

        print("Parsed \(parsedTickers.count) tickers")
        return parsedTickers
    }

    private func parseMoexCandles(_ moexCandles: MoexCandles, ticker: String) throws -> [Candle] {
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
            throw errorHandler.handle(NetworkError.decodingError)
        }

        return parsedCandles
    }
}
