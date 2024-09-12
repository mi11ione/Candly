import Foundation
import Network
import Synchronization

public actor CacheModel: CacheProtocol {
    private let cache: Mutex<[String: (data: Data, timestamp: Date)]>
    private let expirationInterval: TimeInterval

    public init(expirationInterval: TimeInterval = 120) {
        self.cache = Mutex([:])
        self.expirationInterval = expirationInterval
    }

    public func getData(forKey key: String) async -> Data? {
        cache.withLock { cache in
            guard let (data, timestamp) = cache[key] else { return nil }
            guard Date().timeIntervalSince(timestamp) < expirationInterval else {
                cache[key] = nil
                return nil
            }
            return data
        }
    }

    public func setData(_ data: Data, forKey key: String) async {
        cache.withLock { cache in
            cache[key] = (data, Date())
        }
    }

    public func removeData(forKey key: String) async {
        cache.withLock { cache in
            cache[key] = nil
        }
    }

    public func clearAll() async {
        cache.withLock { cache in
            cache.removeAll()
        }
    }
}
