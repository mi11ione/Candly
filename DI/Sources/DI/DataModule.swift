import Data
import Factory

public extension Container {
    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService() }.singleton
    }

    var dataService: Factory<DataServiceProtocol> {
        self { DataService() }.singleton
    }

    var patternRepository: Factory<PatternRepositoryProtocol> {
        self { PatternRepository(dataService: self.dataService()) }.singleton
    }

    var tickerRepository: Factory<TickerRepositoryProtocol> {
        self { TickerRepository(networkService: self.networkService(), dataService: self.dataService()) }.singleton
    }
}
