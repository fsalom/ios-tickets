//
//  NewPasswordView.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 22/7/24.
//

import SwiftUI

struct NewPasswordView: View {
    @EnvironmentObject var deeplinkManager: DeepLinkManager
    @ObservedObject var viewModel: NewPasswordViewModel
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var showAlert = false
    @State private var sendButtonState: ButtonState = .normal
    @State private var navigateToFakeShowToast = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 14) {
                Text(viewModel.userId != nil ? "writeNewPassword" : "updateWriteNewPassword")
                    .font(.system(size: 16, weight: .semibold))
                Text("newPasswordInformation")
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(8)
            }
            .padding(.bottom, viewModel.userId != nil ? 44 : 32)
            .padding(.top, 24)

            VStack {
                CustomTextField(text: $viewModel.password,
                                isFieldValid: $viewModel.uiState.isPasswordValid,
                                title: "newPassword",
                                placeholder: "newPassword",
                                errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.passwordErrorMessage),
                                type: .password,
                                maxLength: 15,
                                isFieldMandatory: true)
                .padding(.bottom, 24)

                CustomTextField(text: $viewModel.repeatPassword,
                                isFieldValid: $viewModel.uiState.arePasswordsEqual,
                                title: "repeatPassword",
                                placeholder: "repeatNewPassword",
                                errorMessage: "passwordsDoNotMatch",
                                type: .password,
                                maxLength: 15,
                                isFieldMandatory: true)
                .padding(.bottom, 24)

                CustomButton(buttonState: $sendButtonState,
                             type: .primary,
                             buttonText: "update") {
                    viewModel.checkIfReadyToChangePassword()
                }
            }
            Spacer()
        }
        .onChange(of: viewModel.uiState.areAllFieldsOk, { _, ok in
            if ok {
                sendButtonState = .loading
                viewModel.changePassword()
            }
        })
        .onChange(of: viewModel.uiState.error, { _, error in
            guard let error else { return }
            sendButtonState = .normal
            handle(this: error)
            viewModel.uiState.areAllFieldsOk = false
        })
        .onChange(of: viewModel.uiState.hasChangePasswordSucceeded, { _, show in
            sendButtonState = .normal
            if viewModel.userId != nil, show {
                errorAlertTitle = "passwordUpdated"
                errorAlertMessage = "passwordUpdatedInfo"
                showAlert = true
            } else {
                navigateToFakeShowToast = true
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorAlertTitle), message: Text(errorAlertMessage), dismissButton: .default(Text("Accept"), action: {
                if viewModel.uiState.hasChangePasswordSucceeded {
                    deeplinkManager.screen = .none
                }
                if errorAlertTitle == "conectionError" {
                    viewModel.changePassword()
                }
                viewModel.uiState.error = nil
            }))
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.userId != nil ? "newPassword" : "password")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        if viewModel.userId != nil  {
                            deeplinkManager.screen = .none
                            deeplinkManager.id = nil
                        }
                        presentation.wrappedValue.dismiss()
                    } label: {
                        toolBarBackButtonImage(systemName: viewModel.userId != nil ? "xmark" : "chevron.left")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(maxWidth: 16, maxHeight: 16)
                    }
                }
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $navigateToFakeShowToast ) {
            FakeViewToShowToastOfAccountChangeBuilder().build(.password)
        }
    }
    
    private func toolBarBackButtonImage(systemName: String) -> Image {
        Image(systemName: systemName)
    }

    private func handle(this error: AuthError) {
        switch error {
        case .inputPasswordError:
            viewModel.uiState.passwordErrorMessage = error.message
            viewModel.uiState.isPasswordValid = false
        case .inputsError(let fields, let messages):
            fields.enumerated().forEach { index, field in
                if field == "password" {
                    viewModel.uiState.passwordErrorMessage = messages[index]
                    viewModel.uiState.isPasswordValid = false
                }
            }
        case .appError, .inputEmailError, .inputUsernameError, .notVerified:
            errorAlertTitle = LocalizedStringKey(error.title)
            errorAlertMessage = LocalizedStringKey(error.message)
            showAlert = true
        }
    }
}
