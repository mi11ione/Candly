import Factory
import Network

extension Container {
    var cacheProtocol: Factory<CacheProtocol> {
        self { self.cacheModel() as CacheProtocol }.singleton
    }

    var cacheManager: Factory<CacheManager> {
        self { CacheManager(cache: self.cacheProtocol()) }.singleton
    }

    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService(cacheManager: self.cacheManager()) }.singleton
    }
}
