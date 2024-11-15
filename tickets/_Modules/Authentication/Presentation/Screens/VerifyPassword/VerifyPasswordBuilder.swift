//
//  VerifyPasswordBuilder.swift
//  Gula
//
//  Created by Adrian Prieto Villena on 4/11/24.
//

import Foundation

class VerifyPasswordBuilder {
    func build(_ navigateToNewPassword: @escaping () -> Void ) -> VerifyPasswordView {
        let errorHandler = ErrorHandlerManager()
        let network = Config.shared.network
        let validationUseCase = ValidationUseCase()

        let dataSource = AuthRemoteDataSource(network: network)
        let repository = AuthRepository(remoteDataSource: dataSource, errorHandler: errorHandler)
        let authUseCase = AuthUseCase(repository: repository)

        let viewModel = VerifyPasswordViewModel(authUseCase: authUseCase, validationUseCase: validationUseCase)
        let view = VerifyPasswordView(viewModel: viewModel, navigateToNewPassword: navigateToNewPassword)
        
        return view
    }
}

// TODO: - How to navigate at this screen, example MainMenu
/**
 NavigationLink("Cambiar contraseña - Cuenta") {
 }
 .onTapGesture {
     isShowingVerifyPassword = true
 }
 .sheet(isPresented: $isShowingVerifyPassword, content: {
     VerifyPasswordBuilder().build({
         isShowingVerifyPassword = false
         isVerifiedActualPassword = true
     })
 })
 .navigationDestination(isPresented: $isVerifiedActualPassword) {
     EmptyView()
 }
 */
