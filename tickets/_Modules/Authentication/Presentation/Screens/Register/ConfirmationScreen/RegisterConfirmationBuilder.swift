//
//  RegisterConfirmationBuilder.swift
//  Gula
//
//  Created by María on 1/8/24.
//

import Foundation

class RegisterConfirmationBuilder {
    func build(with email: String) -> RegisterConfirmationView {
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()

        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let authRepository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: authRepository)

        let viewModel = RegisterConfirmationViewModel(email: email, authUseCase: authUseCase)
        let view = RegisterConfirmationView(viewModel: viewModel)
        return view
    }
}
