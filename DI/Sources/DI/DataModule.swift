import Factory
import Data

public extension Container {
    var dataService: Factory<DataServiceProtocol> {
        self { DataService() }.singleton
    }

    var modelCache: Factory<ModelCache> {
        self { ModelCache() }.singleton
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
