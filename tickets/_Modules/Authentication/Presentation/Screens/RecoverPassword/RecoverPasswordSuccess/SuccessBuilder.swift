//
//  SuccessBuilder.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 18/7/24.
//

import Foundation

class SuccessBuilder {
    func build(with config: SuccesConfig) -> SuccessView {
        
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()
        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)
        let viewModel = SuccessViewModel(useCase: authUseCase)
        let view = SuccessView(viewModel: viewModel, config: config)
        return view
    }
}
