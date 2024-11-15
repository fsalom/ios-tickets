//
//  LogoutBuilder.swift
//  Gula
//
//  Created by Axel Pérez Gaspar on 29/8/24.
//

import Foundation

final class LogoutBuilder {
    func build() -> LogoutView {
        let network = Config.shared.network
        let errorHandler = ErrorHandlerManager()
        let authRemoteDataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: authRemoteDataSource, errorHandler: errorHandler)
        let useCase = AuthUseCase(repository: repository)
        let viewModel = LogoutViewModel(useCase: useCase)
        let view = LogoutView(viewModel: viewModel)
        return view
    }
}
