import Data
import Factory

public extension Container {
    var dataParser: Factory<DataParser> {
        self { DataParser() }.singleton
    }

    var cacheService: Factory<CacheService> {
        self { CacheService() }.singleton
    }

    var patternRepository: Factory<PatternRepositoryProtocol> {
        self { PatternRepository(parser: self.dataParser()) }.singleton
    }

    var tickerRepository: Factory<TickerRepositoryProtocol> {
        self { TickerRepository(networkService: self.networkService()) }.singleton
    }

    var fetchPatternsUseCase: Factory<FetchPatternsUseCaseProtocol> {
        self { FetchPatternsUseCase(repository: self.patternRepository()) }
    }

    var fetchTickersUseCase: Factory<FetchTickersUseCaseProtocol> {
        self { FetchTickersUseCase(repository: self.tickerRepository()) }
    }
}
