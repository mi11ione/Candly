import Foundation

public struct NetworkConfig {
    let minRequestInterval: TimeInterval
    let maxRetries: Int
    let retryDelay: TimeInterval
    let cachePolicy: URLRequest.CachePolicy

    public init(
        minRequestInterval: TimeInterval = 1.0,
        maxRetries: Int = 3,
        retryDelay: TimeInterval = 1.0,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.minRequestInterval = minRequestInterval
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
        self.cachePolicy = cachePolicy
    }
}
