//
//  ChangeEmailBuilder.swift
//  Gula
//
//  Created by Jesu Castellano on 5/11/24.
//

import Foundation

class ChangeEmailBuilder {
    func build() -> ChangeEmailView {
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()
        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)
        let validationUseCase = ValidationUseCase()
        let viewModel = ChangeEmailViewModel(validationUseCase: validationUseCase, authUseCase: authUseCase)
        return ChangeEmailView(viewModel: viewModel)
    }
}
