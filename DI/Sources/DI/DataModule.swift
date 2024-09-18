import Data
import Factory

public extension Container {
    var dataService: Factory<DataService> {
        self { DataService() }.singleton
    }

    var cacheService: Factory<CacheService> {
        self { CacheService() }.singleton
    }

    var patternRepository: Factory<PatternRepositoryProtocol> {
        self { PatternRepository(dataService: self.dataService()) }.singleton
    }

    var tickerRepository: Factory<TickerRepositoryProtocol> {
        self { TickerRepository(networkService: self.networkService(), dataService: self.dataService()) }.singleton
    }

    var fetchPatternsUseCase: Factory<FetchPatternsUseCaseProtocol> {
        self { FetchPatternsUseCase(repository: self.patternRepository()) }
    }

    var fetchTickersUseCase: Factory<FetchTickersUseCaseProtocol> {
        self { FetchTickersUseCase(repository: self.tickerRepository()) }
    }
}
