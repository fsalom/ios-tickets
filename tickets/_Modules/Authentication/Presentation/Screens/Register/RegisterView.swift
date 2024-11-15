//
//  RegisterView.swift
//  Gula
//
//  Created by María on 31/7/24.
//
import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: RegisterViewModel
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var sendButtonState: ButtonState = .disabled
    @State private var isShowingErrorAlert = false
    @State private var shouldNavigateToConfirmEmail = false
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack {
                    VStack {
                        Text("registerTitle")
                            .font(.system(size: 18))
                            .padding(.top, 18)
                        Image(systemName: "photo.fill")
                            .resizable()
                            .frame(width: 83, height: 83)
                            .foregroundColor(Color.gray)
                            .clipShape(Circle())
                            .padding(.top, 24)
                        VStack(spacing: 16) {
                            CustomTextField(
                                text: $viewModel.fullName,
                                isFieldValid: $viewModel.uiState.isValidName,
                                title: "fullName",
                                placeholder: "fullName",
                                errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.usernameErrorMessage),
                                isFieldMandatory: true)
                            emailFieldView
                            passwordFieldsView
                        }
                        .padding(.top, 24)
                    }
                }
            }
            VStack(spacing: 8) {
                registerButtonView
                loginLinkView
            }
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .padding(.horizontal, 16)
        .onChange(of: viewModel.uiState.allFieldsOK, { _, ok in
            sendButtonState = ok ? .normal : .disabled
        })
        .onChange(of: viewModel.uiState.error, {_, error in
            guard let error else { return }
            switch error {
            case .inputEmailError:
                viewModel.uiState.emailErrorMessage = error.message
                viewModel.uiState.isValidEmail = false
            case .inputPasswordError:
                viewModel.uiState.passwordErrorMessage = error.message
                viewModel.uiState.isValidPassword = false
            case .inputUsernameError:
                viewModel.uiState.usernameErrorMessage = error.message
                viewModel.uiState.isValidName = false
            case .inputsError(let fields, let messages):
                fields.enumerated().forEach { index, field in
                    if field == "email"{
                        viewModel.uiState.emailErrorMessage = messages[index]
                        viewModel.uiState.isValidEmail = false
                    }
                    if field == "password"{
                        viewModel.uiState.passwordErrorMessage = messages[index]
                        viewModel.uiState.isValidPassword = false
                    }
                    if field == "username"{
                        viewModel.uiState.usernameErrorMessage = messages[index]
                        viewModel.uiState.isValidName = false
                    }
                }
            default:
                errorAlertTitle = LocalizedStringKey(error.title)
                errorAlertMessage = LocalizedStringKey(error.message)

                isShowingErrorAlert = true
            }
        })
        .onChange(of: viewModel.uiState.createAccountSucceeded, {_, error in
            shouldNavigateToConfirmEmail = true
        })
        .alert(isPresented: $isShowingErrorAlert) {
            Alert(
                title: Text(errorAlertTitle),
                message: Text(errorAlertMessage),
                dismissButton: .default(Text("Accept"), action: {
                    if errorAlertTitle == "conectionError" {
                        viewModel.createAccount()
                    }
                    viewModel.uiState.error = nil
                })
            )
        }
        .navigationDestination(isPresented: $shouldNavigateToConfirmEmail ) {
            RegisterConfirmationBuilder().build(with: viewModel.email)
        }
    }
    
    private var emailFieldView: some View {
        VStack(alignment: .leading, spacing: 8) {
            CustomTextField(
                text: $viewModel.email,
                isFieldValid: $viewModel.uiState.isValidEmail,
                title: "email",
                placeholder: "writeEmail",
                errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.emailErrorMessage),
                isFieldMandatory: true)
        }
    }
    
    private var passwordFieldsView: some View {
        VStack(spacing: 16) {
            CustomTextField(
                text: $viewModel.password,
                isFieldValid: $viewModel.uiState.isValidPassword,
                title: "password",
                subtitle: passwordSubtitle,
                placeholder: "password",
                errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.passwordErrorMessage),
                type: .password,
                isFieldMandatory: true)
            
            VStack(alignment: .leading, spacing: 8) {
                CustomTextField(
                    text: $viewModel.repeatPassword,
                    isFieldValid: $viewModel.uiState.isValidRepeatPassword,
                    title: "repeatPassword",
                    placeholder: "repeatPassword",
                    errorMessage: viewModel.password.isEmpty ? "" : "passwordsDoNotMatch",
                    type: .password,
                    isFieldMandatory: true)
            }
        }
    }
    
    private var passwordSubtitle: Text {
        Text("passwordFirstText")
        + Text(" ")
        + Text("passwordSecondTextBold").bold()
        + Text(" ")
        + Text("passwordThirdText")
        + Text(" ")
        + Text("passwordFourthTextBold").bold()
    }
    
    private var registerButtonView: some View {
        VStack {
            CustomButton(
                buttonState: $sendButtonState,
                type: .secondary,
                buttonText: "createAccount")
            {
                sendButtonState = .loading
                viewModel.createAccount()
                sendButtonState = .normal
            }
        }
    }
    
    private var loginLinkView: some View {
        HStack(alignment: .center) {
            Text("haveAccountText")
                .font(.system(size: 14))
                .foregroundColor(.black)
            
            NavigationLink(destination: LoginViewBuilder().build(isSocialLoginActived: false)) {
                HStack(spacing: 0) {
                    Text("loginLowercased")
                        .underline()
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
        }
    }
}
