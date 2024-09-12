import Foundation

public actor CacheManager {
    private let cache: CacheProtocol

    public init(cache: CacheProtocol) {
        self.cache = cache
    }

    public func getCachedData(forKey key: String) async -> Data? {
        await cache.getData(forKey: key)
    }

    public func cacheData(_ data: Data, forKey key: String) async {
        await cache.setData(data, forKey: key)
    }

    public func removeCachedData(forKey key: String) async {
        await cache.removeData(forKey: key)
    }

    public func clearCache() async {
        await cache.clearAll()
    }
}
