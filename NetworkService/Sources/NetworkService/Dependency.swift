import Factory

public extension Container {
    var networkService: Factory<NetworkServiceProtocol> {
        self { NetworkService() }
    }
}
