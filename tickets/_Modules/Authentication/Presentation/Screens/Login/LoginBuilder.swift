//
//  LoginBuilder.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 5/7/24.
//

import Foundation

class LoginViewBuilder {
    func build(isSocialLoginActived: Bool) -> LoginView {
        let errorHandler = ErrorHandlerManager()
        let network = Config.shared.network
        let validationUseCase = ValidationUseCase()

        let dataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: dataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)

        let viewModel = LoginViewModel(validationUseCase: validationUseCase, authUseCase: authUseCase)
        let view = LoginView(viewModel: viewModel, isSocialLoginActived: isSocialLoginActived)
        return view
    }
}
