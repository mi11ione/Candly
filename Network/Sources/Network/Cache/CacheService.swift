import Foundation

public actor CacheService<Key: Hashable, Value> {
    private var cache: [Key: (value: Value, timestamp: Date)] = [:]
    private let expirationInterval: TimeInterval

    public init(expirationInterval: TimeInterval = 120) {
        self.expirationInterval = expirationInterval
    }

    public func getValue(forKey key: Key) -> Value? {
        guard let (value, timestamp) = cache[key] else { return nil }
        guard Date().timeIntervalSince(timestamp) < expirationInterval else {
            cache[key] = nil
            return nil
        }
        return value
    }

    public func setValue(_ value: Value, forKey key: Key) {
        cache[key] = (value, Date())
    }

    public func clear() {
        cache.removeAll()
    }
}

public struct CandleCacheKey: Hashable, Sendable {
    private let ticker: String
    private let time: Time

    public init(ticker: String, time: Time) {
        self.ticker = ticker
        self.time = time
    }
}
