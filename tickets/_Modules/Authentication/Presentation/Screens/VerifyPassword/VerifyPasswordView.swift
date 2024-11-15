//
//  VerifyPasswordView.swift
//  Gula
//
//  Created by Adrian Prieto Villena on 4/11/24.
//

import SwiftUI

struct VerifyPasswordView: View {
    @StateObject var viewModel: VerifyPasswordViewModel
    @State var buttonState: ButtonState = .normal
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var isShowingErrorAlert = false
    var navigateToNewPassword: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("updatePassword")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.top, 16)
                        Text("updatePasswordMessage")
                            .font(.system(size: 14, weight: .regular))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    CustomTextField(
                        text: $viewModel.password,
                        isFieldValid: $viewModel.uiState.isValidPassword,
                        hasUserStartedTyping: viewModel.uiState.hasStartTyping,
                        areValidationsActive: true,
                        placeholder: "actualPassword",
                        errorMessage: LocalizedStringKey(stringLiteral: viewModel.passwordErrorMessage),
                        type: .password,
                        maxLength: 15
                    )
                    .padding(.bottom, viewModel.uiState.isValidPassword ? 16 : 6)
                }
                CustomButton(
                    buttonState: $buttonState,
                    type: .primary,
                    buttonText: "continue",
                    action: {
                        viewModel.verifyPassword()
                    }
                )
            }
            .padding(.horizontal, 16)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .presentationDetents([.height(204)])
            .onChange(of: viewModel.uiState.error, { _, error in
                guard let error else { return }
                handle(this: error)
            })
            .alert(isPresented: $isShowingErrorAlert) {
                Alert(
                    title: Text(errorAlertTitle),
                    message: Text(errorAlertMessage),
                    dismissButton: .default(Text("Accept"), action: {
                        if errorAlertTitle == "conectionError" {
                            viewModel.verifyPassword()
                        }
                        viewModel.uiState.error = nil
                    })
                )
            }
            .onChange(of: viewModel.uiState.isVerified) { _, isVerified in
                if isVerified {
                    navigateToNewPassword()
                }
            }
        }
    }

    private func handle(this error: AuthError) {
        switch error {
        case .inputPasswordError:
            viewModel.passwordErrorMessage = error.message
            viewModel.uiState.isValidPassword = false
        case .appError, .inputEmailError, .inputUsernameError, .inputsError, .notVerified:
            errorAlertTitle = LocalizedStringKey(error.title)
            errorAlertMessage = LocalizedStringKey(error.message)
            isShowingErrorAlert = true
        }
    }
}

#Preview {
    VerifyPasswordBuilder().build {
    }
}
