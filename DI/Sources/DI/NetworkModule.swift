import Factory
import Network

public extension Container {
    var cacheManager: Factory<CacheManager> {
        self { CacheManager(cache: self.modelCache()) }.singleton
    }

    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService(cacheManager: self.cacheManager()) }.singleton
    }
}
