import Foundation

public protocol CacheProtocol: Actor {
    func getCachedData(forKey key: String) async -> Data?
    func cacheData(_ data: Data, forKey key: String) async
    func getCachedDataArray(forKey key: String, time: Time) async -> Data?
    func cacheDataArray(_ data: Data, forKey key: String, time: Time) async
    func clearCache() async
}
