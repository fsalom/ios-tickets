//
//  ChangeEmailView.swift
//  Gula
//
//  Created by Jesu Castellano on 5/11/24.
//

import SwiftUI

struct ChangeEmailView: View {
    @ObservedObject var viewModel: ChangeEmailViewModel
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var showAlert = false
    @FocusState private var isEmailFieldFocused: Bool
    @Environment(\.presentationMode) var presentation
    @State private var isFieldEmptyCheckedFromView = false

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    DispatchQueue.main.async {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    }
                }
            VStack {
                VStack (spacing: 8) {
                    Text("Actualizar correo electrónico")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.system(size: 14))
                        .bold()
                    Text("changeEmailInfo")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
                
                VStack(spacing: 18) {
                    CustomTextField(text: $viewModel.email,
                                    isFieldValid: $viewModel.uiState.isEmailValid,
                                    title: "newEmail",
                                    placeholder: "writeEmail",
                                    errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.emailErrorMessage),
                                    isFieldMandatory: true,
                                    isFieldEmptyCheckedFromView: isFieldEmptyCheckedFromView
                    )
                    CustomButton(buttonState: $viewModel.uiState.sendButtonState,
                                 type: .primary,
                                 buttonText: "update") {
                        viewModel.changeEmail()
                    }
                }
                .padding(.top, 30)
                Spacer()
            }
            .padding(16)
        }
        .navigationDestination(isPresented: $viewModel.uiState.hasEmailBeenSent, destination: {
            // TODO: - Parse viewModel.currentEmail instead of viewModel.email
            let config = SuccesConfig(title: "changeEmailTitle",
                                      message: "changeDescription, \(viewModel.email)",
                                      parameter: viewModel.email,
                                      messageType: .changeEmail)
            SuccessBuilder().build(with: config)
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: viewModel.uiState.error) { _, error in
            guard let error  else { return }
            handle(error: error)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorAlertTitle), message: Text(errorAlertMessage), dismissButton: .default(Text("Accept"), action: {
                viewModel.uiState.error = nil
            }))
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("changeEmailToolbarTitle")
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
    }

    private func handle(error: AuthError) {
        switch error {
        case .inputEmailError:
            isFieldEmptyCheckedFromView = true
            viewModel.uiState.emailErrorMessage = error.message
            viewModel.uiState.isEmailValid = false
            viewModel.uiState.error = nil
        case .notVerified, .appError, .inputUsernameError, .inputsError, .inputPasswordError:
            errorAlertTitle = LocalizedStringKey(stringLiteral: error.title)
            errorAlertMessage = LocalizedStringKey(stringLiteral: error.message)
            showAlert = true
        }
    }
}

#Preview {
    ChangeEmailBuilder().build()
}
