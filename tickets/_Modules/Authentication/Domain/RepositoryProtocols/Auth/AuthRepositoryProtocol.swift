//
//  AuthRepositoryProtocol.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 10/7/24.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(with email: String, and password: String) async throws
    func recoverPassword(with email: String) async throws
    func changePassword(password: String, id: String) async throws
    func changeEmail(email: String) async throws
    func loginWithApple(code: String) async throws
    func loginWithGoogle(token: String) async throws
    func logout() async throws
    func isUserLogged() async -> Bool
    func createAccount(fullName: String, email: String, password: String) async throws
    func resendLinkVerification(email: String) async throws
    func validatePassword(_ password: String) async throws
    func deleteAccount() async throws
    func updatePassword(with password: String) async throws
}
