import Factory
import NetworkService

public extension Container {
    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService() }
    }
}
