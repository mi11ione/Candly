import Data
import Factory
import Network

public extension Container {
    var modelCache: Factory<CacheProtocol> {
        self { ModelCache() }.singleton
    }

    var cacheManager: Factory<CacheManager> {
        self { CacheManager(cache: self.modelCache()) }.singleton
    }

    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService(cacheManager: self.cacheManager()) }.singleton
    }
}
