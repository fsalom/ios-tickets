//
//  DeeplinkManager.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 23/7/24.
//

import Foundation

class DeepLinkManager: ObservableObject {
    enum DeeplinkDestination: String {
        case none = "__none__"
        case newPassword = "newpassword"
        case registerComplete = "register/verify"
        case changeEmailComplete = "change-email/verify"
        case home = "home"
    }

    @Published var screen: DeeplinkDestination = .none
    @Published var id: String?

    var scheme: String

    init(scheme: String) {
        self.scheme = scheme
    }

    func manage(this deeplink: URL) {
        if deeplink.scheme == self.scheme {
            let path = "\(deeplink.host ?? "")\(deeplink.path)"
            self.screen = DeeplinkDestination(rawValue: path) ?? .none

            if let components = URLComponents(url: deeplink, resolvingAgainstBaseURL: false) {
                let queryItems = components.queryItems ?? []
                
                if let idItem = queryItems.first(where: { $0.name == "suid" })?.value {
                    self.id = idItem.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
                }
            }
        }
    }
}
