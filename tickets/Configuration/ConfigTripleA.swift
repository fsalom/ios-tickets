//
//  Configuration.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 11/7/24.
//

import Foundation
import TripleA

class ConfigTripleA: TripleAForSwiftUIProtocol {
    private enum OAuthAPI {
        case login
        case refresh
        var endpoint: Endpoint {
            get {
                switch self {
                case .login:
                    let parameters: [String: String] = ["client_id": Config.client_id]
                    let headers: [String: String] = ["Accept-Language": Locale.current.identifier]
                    return Endpoint(path: "\(Config.baseURL)api/v1/auth/login",
                                    httpMethod: .post,
                                    parameters: parameters,
                                    headers: headers)
                case .refresh:
                    let parameters = ["grant_type": "refresh_token",
                                      "client_id": Config.client_id]
                    return Endpoint(path: "\(Config.baseURL)api/v1/auth/refresh",
                                    httpMethod: .post,
                                    parameters: parameters)
                }
            }
        }
    }
    
    internal var storage: TokenStorageProtocol = AuthTokenStoreDefault(format: .full)
    internal var card: AuthenticationCardProtocol = OAuthGrantTypePasswordManager(
        refreshTokenEndpoint: OAuthAPI.refresh.endpoint,
        tokensEndpoint: OAuthAPI.login.endpoint)
    
    lazy var appAuthenticator = AppAuthenticator(
        storage: storage,
        card: card)

    lazy var authenticator: AuthenticatorSUI = AuthenticatorSUI(authenticator: appAuthenticator)

    
    lazy var network = Network(authenticator: Config.shared.authenticator,
                               format: .short)

    var authenticatedTestingEndpoint: TripleA.Endpoint? = Endpoint(path: "", httpMethod: .get)
}
