//
//  RecoverPasswordBuilder.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 17/7/24.
//

import Foundation

class RecoverPasswordBuilder {
    func build() -> RecoverPasswordView {
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()
        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)
        let validationUseCase = ValidationUseCase()
        let viewModel = RecoverPasswordViewModel(validationUseCase: validationUseCase, authUseCase: authUseCase)
        let view = RecoverPasswordView(viewModel: viewModel)
        return view
    }
}
