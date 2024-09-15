import Foundation
import Network

public actor CacheService: CacheProtocol {
    private let cache: NSCache<NSString, CacheEntry>
    private let expirationInterval: TimeInterval

    public init(expirationInterval: TimeInterval = 120) {
        cache = NSCache()
        self.expirationInterval = expirationInterval
    }

    public func getData(forKey key: String) -> Data? {
        guard let entry = cache.object(forKey: key as NSString) else { return nil }
        guard Date().timeIntervalSince(entry.timestamp) < expirationInterval else {
            cache.removeObject(forKey: key as NSString)
            return nil
        }
        return entry.data
    }

    public func setData(_ data: Data, forKey key: String) {
        let entry = CacheEntry(data: data, timestamp: Date())
        cache.setObject(entry, forKey: key as NSString)
    }

    public func removeData(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    public func clearAll() {
        cache.removeAllObjects()
    }
}

private class CacheEntry {
    let data: Data
    let timestamp: Date

    init(data: Data, timestamp: Date) {
        self.data = data
        self.timestamp = timestamp
    }
}
