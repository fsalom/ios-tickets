//
//  ticketsApp.swift
//  tickets
//
//  Created by Fernando Salom Carratala on 15/11/24.
//

import SwiftUI
import SwiftData
import TripleA
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ticketsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticator: AuthenticatorSUI = Config.shared.authenticator

        var body: some Scene {
            WindowGroup {
                AuthSwitcherViewBuilder().build(isSocialLoginActived: true)
                    .environmentObject(authenticator)
            }
        }
}
