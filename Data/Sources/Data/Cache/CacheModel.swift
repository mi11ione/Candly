import Foundation
import Network

public actor CacheModel: CacheProtocol {
    private var cache: [String: (data: Data, timestamp: Date)] = [:]
    private let expirationInterval: TimeInterval

    public init(expirationInterval: TimeInterval = 120) {
        self.expirationInterval = expirationInterval
    }

    public func getData(forKey key: String) async -> Data? {
        guard let (data, timestamp) = cache[key] else { return nil }
        guard Date().timeIntervalSince(timestamp) < expirationInterval else {
            cache[key] = nil
            return nil
        }
        return data
    }

    public func setData(_ data: Data, forKey key: String) async {
        cache[key] = (data, Date())
    }

    public func removeData(forKey key: String) async {
        cache[key] = nil
    }

    public func clearAll() async {
        cache.removeAll()
    }
}
