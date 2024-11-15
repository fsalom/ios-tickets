//
//  GenericError.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 12/7/24.
//

import Foundation

protocol DetailErrorProtocol: Error {
    var title: String { get }
    var message: String { get }
}

enum AppError: DetailErrorProtocol, Equatable {
    case generalError
    case noInternet
    case badCredentials(String)
    case customError(String, Int?)
    case inputError(String,String)
    case inputsError([String],[String])

    var title: String {
        switch self {
        case .inputError(let field, _):
            return field
        case .noInternet:
            return "conectionError"
        default:
            return "tryAgain"
        }
    }
    
    var message: String {
        switch self {
        case .generalError:
            return "generalError"
        case .customError(let message, _):
            return message
        case .noInternet:
            return "noInternetMessage"
        case .badCredentials(_):
            return "badCredentials"
        case .inputError(_, let message):
            return message
        case .inputsError(_, let messages):
            return ""
        }
    }
}
