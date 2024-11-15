//
//  ticketsApp.swift
//  tickets
//
//  Created by Fernando Salom Carratala on 15/11/24.
//

import SwiftUI
import SwiftData
import TripleA

@main
struct ticketsApp: App {
    @StateObject var authenticator: AuthenticatorSUI = Config.shared.authenticator

        var body: some Scene {
            WindowGroup {
                AuthSwitcherViewBuilder().build(isSocialLoginActived: true)
                    .environmentObject(authenticator)
            }
        }
}
