//
//  RecoverPasswordView.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 17/7/24.
//

import SwiftUI

struct RecoverPasswordView: View {
    @ObservedObject var viewModel: RecoverPasswordViewModel
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var showAlert = false
    @FocusState private var isEmailFieldFocused: Bool
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Text("recoverPasswordInfo")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .padding(.horizontal, 56)
                    .padding(.top, 36)
                VStack(spacing: 20) {
                    CustomTextField(text: $viewModel.email,
                                    isFieldValid: $viewModel.uiState.isEmailValid,
                                    title: "email",
                                    placeholder: "writeEmail",
                                    errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.emailErrorMessage),
                                    isFieldMandatory: true)
                    CustomButton(buttonState: $viewModel.uiState.sendButtonState,
                                 type: .secondary,
                                 buttonText: "send") {
                        viewModel.recoverPassword()
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationDestination(isPresented: $viewModel.uiState.hasEmailBeenSent, destination: {
            let config = SuccesConfig(title: "emailSent",
                                      message: "emailSentInfo, \(viewModel.email)",
                                      parameter: nil,
                                      messageType: .recoverPassword)
            SuccessBuilder().build(with: config)
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.uiState.error, {
            _, error in
            guard let error else { return }
            switch error {
            case .inputEmailError:
                viewModel.uiState.emailErrorMessage = error.message
                viewModel.uiState.isEmailValid = false
            case .inputsError(let fields, let messages):
                fields.enumerated().forEach { index, field in
                    if field == "email"{
                        viewModel.uiState.emailErrorMessage = messages[index]
                        viewModel.uiState.isEmailValid = false
                    }
                }
            default:
                errorAlertTitle = LocalizedStringKey(error.title)
                errorAlertMessage = LocalizedStringKey(error.message)
                showAlert = true
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorAlertTitle), message: Text(errorAlertMessage), dismissButton: .default(Text("Accept"), action: {
                if errorAlertTitle == "conectionError" {
                    viewModel.recoverPassword()
                }
                viewModel.uiState.error = nil
            }))
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("recoverPassword")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(maxWidth: 16, maxHeight: 16)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .toolbarBackground(.gray, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
