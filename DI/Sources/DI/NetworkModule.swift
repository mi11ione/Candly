import Factory
import Network

public extension Container {
    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService() }.singleton
    }
}
