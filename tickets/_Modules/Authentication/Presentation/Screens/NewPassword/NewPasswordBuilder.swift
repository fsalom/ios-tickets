//
//  NewPasswordBuilder.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 22/7/24.
//

import Foundation

class NewPasswordBuilder {
    func build(with id: String?) -> NewPasswordView {
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()
        let validationUseCase = ValidationUseCase()

        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)

        let viewModel = NewPasswordViewModel(userId: id, validationUseCase: validationUseCase, authUseCase: authUseCase)
        let view = NewPasswordView(viewModel: viewModel)
        return view
    }
}
