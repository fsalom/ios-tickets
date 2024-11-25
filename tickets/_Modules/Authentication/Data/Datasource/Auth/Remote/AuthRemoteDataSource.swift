//
//  AuthDataSource.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 10/7/24.
//

import Foundation
import TripleA

class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let network: Network
    private let configuration: ConfigTripleA
    
    init(network: Network, configuration: ConfigTripleA = Config.shared) {
        self.network = network
        self.configuration = configuration
    }
    
    func login(with email: String, and password: String) async throws {
        let parameters = ["username": email,
                          "password": password]
        try await self.network.authenticator?.getNewToken(with: parameters, endpoint: nil)
    }
    
    func loginWithApple(code: String) async throws {
        let parameters = ["auth_code": code]
        let endpoint = Endpoint(path: "\(Config.baseURL)api/v1/auth/apple", httpMethod: .post)
        try await self.network.authenticator?.getNewToken(with: parameters, endpoint: endpoint)
    }
    
    func loginWithGoogle(token: String) async throws {
        let parameters = ["id_token": token, "client_id": Config.client_id]
        let endpoint = Endpoint(path: "\(Config.baseURL)api/v1/auth/google", httpMethod: .post)
        try await self.network.authenticator?.getNewToken(with: parameters, endpoint: endpoint)
    }
    
    func recoverPassword(with email: String) async throws {
        let parameters = ["email": email]
        let endpoint = Endpoint(path: "api/users/recover-password", httpMethod: .post, parameters: parameters)
        _ = try await network.load(this: endpoint)
    }
    
    func changePassword(password: String, id: String) async throws {
        let parameters = ["new_password": password,
                          "suid": id]
        let endpoint = Endpoint(path: "api/users/change-password", httpMethod: .put, parameters: parameters)
        _ = try await network.load(this: endpoint)
    }

    func updatePassword(with password: String) async throws {
        let parameters = ["password": password]
        let endpoint = Endpoint(path: "api/users/change-old-password", httpMethod: .put, parameters: parameters)
        _ = try await network.loadAuthorized(this: endpoint)
    }
    
    func changeEmail(email: String) async throws {
        let parameters = ["email": email]
        let endpoit = Endpoint(path: "api/users/change-email", httpMethod: .put, parameters: parameters)
        _ = try await network.loadAuthorized(this: endpoit)
    }
    
    func logout() async throws {
        try await configuration.authenticator.logout()
        let endpoint = Endpoint(path: "api/users/logout", httpMethod: .post)
        _ = try await self.network.loadAuthorized(this: endpoint)
    }

    func isUserLogged() async -> Bool {
        guard let isLogged = await network.authenticator?.isLogged() else {
            return false
        }
        return isLogged
    }

    func createAccount(fullName: String, email: String, password: String) async throws {
        let parameters = ["fullname": fullName,
                          "email": email,
                          "password": password]
        let endpoint = Endpoint(path: "api/users/create", httpMethod: .post, parameters: parameters)
        _ = try await network.load(this: endpoint)
    }

    func resendLinkVerification(email: String) async throws {
        let parameters = ["email": email]
        let endpoint = Endpoint(path: "api/users/resend-link", httpMethod: .post, parameters: parameters)
        _ = try await network.load(this: endpoint)
    }

    func validatePassword(_ password: String) async throws {
        let parameters = ["password": password]
        let endpoint = Endpoint(path: "api/users/validate-password", httpMethod: .post, parameters: parameters)
        _ = try await network.loadAuthorized(this: endpoint)
    }

    func deleteAccount() async throws {
        let endpoint = Endpoint(path: "api/users/delete", httpMethod: .delete)
        _ = try await network.loadAuthorized(this: endpoint)
    }
}
