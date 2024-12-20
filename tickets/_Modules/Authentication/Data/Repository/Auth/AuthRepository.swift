//
//  AuthRepository.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 10/7/24.
//

import Foundation

class AuthRepository: AuthRepositoryProtocol {
    // MARK: - Properties
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let errorHandler: ErrorHandlerProtocol
    
    // MARK: - Init
    init(remoteDataSource: AuthRemoteDataSourceProtocol, errorHandler: ErrorHandlerProtocol) {
        self.remoteDataSource = remoteDataSource
        self.errorHandler = errorHandler
    }
    
    // MARK: - Functions
    func login(with email: String, and password: String) async throws {
        do {
            try await remoteDataSource.login(with: email, and: password)
        } catch {
            throw errorHandler.handle(error)
        }
    }
    
    func recoverPassword(with email: String) async throws {
        do {
            try await remoteDataSource.recoverPassword(with: email)
        } catch {
            throw errorHandler.handle(error)
        }
    }
    
    func changePassword(password: String, id: String) async throws {
        do {
            try await remoteDataSource.changePassword(password: password, id: id)
        } catch {
            throw errorHandler.handle(error)
        }
    }

    func updatePassword(with password: String) async throws {
        do {
            try await remoteDataSource.updatePassword(with: password)
        } catch {
            throw errorHandler.handle(error)
        }
    }
    
    func changeEmail(email: String) async throws {
        do {
            try await remoteDataSource.changeEmail(email: email)
        } catch {
            throw errorHandler.handle(error)
        }
    }
    
    func logout() async throws {
        do {
            try await remoteDataSource.logout()
        } catch {
            throw errorHandler.handle(error)
        }
    }
    
    func loginWithApple(code: String) async throws {
        do {
            try await remoteDataSource.loginWithApple(code: code)
        } catch {
            throw errorHandler.handle(error)
        }
    }
    
    func loginWithGoogle(token: String) async throws {
        do {
            try await remoteDataSource.loginWithGoogle(token: token)
        } catch {
            throw errorHandler.handle(error)
        }
    }

    func isUserLogged() async -> Bool {
        await remoteDataSource.isUserLogged()
    }

    func createAccount(fullName: String, email: String, password: String) async throws {
        do {
            try await remoteDataSource.createAccount(fullName: fullName, email: email, password: password)
        } catch {
            throw errorHandler.handle(error)
        }
    }

    func resendLinkVerification(email: String) async throws {
        do {
            try await remoteDataSource.resendLinkVerification(email: email)
        } catch {
            throw errorHandler.handle(error)
        }
    }

    func validatePassword(_ password: String) async throws {
        do {
            try await remoteDataSource.validatePassword(password)
        } catch {
            throw errorHandler.handle(error)
        }
    }

    func deleteAccount() async throws {
        do {
            try await remoteDataSource.deleteAccount()
        } catch {
            throw errorHandler.handle(error)
        }
    }
}
