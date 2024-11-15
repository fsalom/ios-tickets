//
//  RegisterBuilder.swift
//  Gula
//
//  Created by María on 31/7/24.
//

import Foundation

class RegisterBuilder {
    func build() -> RegisterView {
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()
        let validationUseCase = ValidationUseCase()

        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let authRepository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: authRepository)

        let viewModel = RegisterViewModel(validationUseCase: validationUseCase, authUseCase: authUseCase)
        let view = RegisterView(viewModel: viewModel)
        return view
    }
}
