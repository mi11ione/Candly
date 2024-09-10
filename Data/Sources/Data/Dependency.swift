import Factory
import NetworkService

public extension Container {
    var dataService: Factory<DataServiceProtocol> {
        self { DataService() }
    }

    var patternRepository: Factory<PatternRepositoryProtocol> {
        self { PatternRepository(dataService: self.dataService()) }
    }

    var tickerRepository: Factory<TickerRepositoryProtocol> {
        self { TickerRepository(networkService: self.networkService(), dataService: self.dataService()) }
    }
}
