//
//  DeleteAccountBuilder.swift
//  Gula
//
//  Created by Jorge on 29/10/24.
//

import Foundation

class DeleteAccountBuilder {
    func build() -> DeleteAccountView {
        let errorHandler = ErrorHandlerManager()
        let network = Config.shared.network

        let dataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: dataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)

        let viewModel = DeleteAccountViewModel(authUseCase: authUseCase)
        let view = DeleteAccountView(viewModel: viewModel)
        return view
    }
}
