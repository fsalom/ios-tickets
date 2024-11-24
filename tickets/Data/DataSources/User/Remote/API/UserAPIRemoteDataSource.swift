import TripleA

class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func get() async throws -> User {
        let endpoint = Endpoint(path: "https://tickets.rudo.es/api/v1/users/me", httpMethod: .get)
        let data = try await network.loadAuthorized(this: endpoint,
                                                    of: UserDTO.self)
        return data.toDomain()
    }

    func update(fcmToken: String) async throws {
        let parameters = ["device_id": fcmToken,
                          "platform": "ios"]
        let endpoint = Endpoint(path: "https://tickets.rudo.es/api/v1/users/me/device",
                                httpMethod: .patch,
                                parameters: parameters)
        _ = try await network.loadAuthorized(this: endpoint)
    }
}

fileprivate extension UserDTO {
    func toDomain() -> User {
        return User(email: self.email)
    }
}
