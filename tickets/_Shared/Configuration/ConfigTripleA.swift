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
                    let parameters: [String: String] = [:]
                    let headers: [String: String] = ["Accept-Language": Locale.current.identifier]
                    return Endpoint(path: "\(Config.baseURL)api/users/login",
                                    httpMethod: .post,
                                    parameters: parameters,
                                    headers: headers)
                case .refresh:
                    let parameters = ["grant_type": "refresh_token",
                                      "client_id": Config.client_id,
                                      "client_secret": Config.client_secret]
                    return Endpoint(path: "\(Config.baseURL)auth/token/",
                                    httpMethod: .post,
                                    parameters: parameters)
                }
            }
        }
    }
    
    internal var storage: TokenStorageProtocol = AuthTokenStoreDefault(format: .short)
    internal var card: AuthenticationCardProtocol = OAuthGrantTypePasswordManager(
        refreshTokenEndpoint: OAuthAPI.refresh.endpoint,
        tokensEndpoint: OAuthAPI.login.endpoint)
    
    lazy var appAuthenticator = AppAuthenticator(
        storage: storage,
        card: card)

    lazy var authenticator: AuthenticatorSUI = AuthenticatorSUI(authenticator: appAuthenticator)
    
    lazy var network = Network(baseURL: Config.baseURL,
                               authenticator: Config.shared.authenticator,
                               format: .full)
    
    var authenticatedTestingEndpoint: TripleA.Endpoint? = Endpoint(path: "", httpMethod: .get)
}
