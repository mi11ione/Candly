import Domain
import Factory

public extension Container {
    var fetchPatternsUseCase: Factory<FetchPatternsUseCaseProtocol> {
        self { FetchPatternsUseCase(repository: self.patternRepository()) }
    }

    var fetchTickersUseCase: Factory<FetchTickersUseCaseProtocol> {
        self { FetchTickersUseCase(repository: self.tickerRepository()) }
    }
}
