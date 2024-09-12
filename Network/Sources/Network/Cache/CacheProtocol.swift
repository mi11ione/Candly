import Foundation

public protocol CacheProtocol: Actor {
    func getData(forKey key: String) async -> Data?
    func setData(_ data: Data, forKey key: String) async
    func removeData(forKey key: String) async
    func clearAll() async
}
