import Factory
import Network

public extension Container {
    var cacheProtocol: Factory<CacheProtocol> {
        self { self.modelCache() as CacheProtocol }.singleton
    }

    var cacheManager: Factory<CacheManager> {
        self { CacheManager(cache: self.cacheProtocol()) }.singleton
    }

    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService(cacheManager: self.cacheManager()) }.singleton
    }
}
