//
//  LoginView.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 4/7/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: LoginViewModel
    @State private var showAlert = false
    @State private var buttonState: ButtonState = .disabled
    // TODO: Implement when Home Module added
//    @State private var shouldNavigateToHome = false
    let isSocialLoginActived: Bool

    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 83, height: 83)
                    .foregroundColor(Color.gray)
                    .clipShape(Circle())
                    .padding(.top, 24)
                VStack(spacing: 16) {
                    CustomTextField(text: $viewModel.email,
                                    isFieldValid: $viewModel.uiState.isEmailValid,
                                    title: "email",
                                    placeholder: "writeEmail",
                                    errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.emailErrorMessage),
                                    isFieldMandatory: true)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        CustomTextField(text: $viewModel.password,
                                        isFieldValid: $viewModel.uiState.isPasswordValid,
                                        title: "password",
                                        placeholder: "password",
                                        errorMessage: LocalizedStringKey(stringLiteral: viewModel.uiState.passwordErrorMessage),
                                        type: .password,
                                        isFieldMandatory: true)
                        NavigationLink(destination: RecoverPasswordBuilder().build()) {
                            Text("forgotPassword")
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .padding(.top, 24)
                CustomButton(buttonState: $buttonState,
                             type: .secondary,
                             buttonText: "LogIn") {
                    viewModel.login()
                }
                             .padding(.top, 20)
                if isSocialLoginActived {
                    socialLoginView
                        .padding(.top, 20)
                }
                Spacer()
                HStack(alignment: .center) {
                    Text("noAccountYet")
                        .font(.system(size: 14))
                    NavigationLink(destination: RegisterBuilder().build()) {
                        Text("register")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundStyle(.black)
                            .underline()
                    }
                }
                .padding(.bottom, 20)
            }
            .overlay(
                VStack {
                    if viewModel.uiState.showToast {
                        ToastView(isVisible: $viewModel.uiState.showToast, message: "linkSent", isCloseButtonActive: true, closeAction: {
                            viewModel.uiState.showToast = false
                        })
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    withAnimation {
                                        viewModel.uiState.showToast = false
                                    }
                                }
                            }
                            .padding(.bottom, 8)
                    }
                }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            )
            .animation(.easeInOut, value: viewModel.uiState.showToast)
            .onChange(of: viewModel.uiState.allFieldsAreValid) { _, areValid in
                buttonState = areValid ? .normal : .disabled
            }
            .onChange(of: viewModel.uiState.isLoginSuccessful) { _, _ in
                // TODO: Implement when Home Module added
//                shouldNavigateToHome = true
            }
            .onChange(of: viewModel.uiState.error) { _, _ in
                guard let error = viewModel.uiState.error else { return }
                
                switch error {
                case .inputEmailError:
                    viewModel.uiState.emailErrorMessage = error.message
                    viewModel.uiState.isEmailValid = false
                case .inputPasswordError:
                    viewModel.uiState.passwordErrorMessage = error.message
                    viewModel.uiState.isPasswordValid = false
                case .inputsError(let fields, let messages):
                    fields.enumerated().forEach { index, field in
                        if field == "email"{
                            viewModel.uiState.emailErrorMessage = messages[index]
                            viewModel.uiState.isEmailValid = false
                        }
                        if field == "password"{
                            viewModel.uiState.passwordErrorMessage = messages[index]
                            viewModel.uiState.isPasswordValid = false
                        }
                    }
                case .notVerified,.appError,.inputUsernameError:
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                setupAlert(for: viewModel.uiState.error!)
            }
            .padding(.horizontal,16)
        }
        // TODO: Implement when Home Module added
//        .navigationDestination(isPresented: $shouldNavigateToHome) {
//            HomeBuilder().build(isLogged: Container.isLogged)
//        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(maxWidth: 16, maxHeight: 16)
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("LogIn")
                    .font(.system(size: 18))
            }
        }
    }

    private var socialLoginView: some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.gray)
                Text("socialLoginTitle")
                    .lineLimit(1)
                    .font(.system(size: 12))
                    .fixedSize()
                    .foregroundStyle(Color.gray)
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.gray)
            }
            SocialLoginButton(buttonType: .apple) {
                viewModel.loginWithApple()
            }
            .padding(.top, 20)
            SocialLoginButton(buttonType: .google) {
                viewModel.loginWithGoogle()
            }
        }
    }


    private func setupAlert(for error: AuthError) -> Alert {
        switch error {
            case .appError(_, _):
                return Alert(
                    title: Text(LocalizedStringKey(error.title)),
                    message: Text(LocalizedStringKey(error.message)),
                    dismissButton: .default(Text(LocalizedStringKey("Accept")), action: {
                        if error.title == "conectionError" {
                            viewModel.tryCallAgain()
                        }
                        viewModel.uiState.error = nil
                    })
                )
            case .notVerified:
                return Alert(
                    title: Text(LocalizedStringKey(error.title)),
                    message: Text(LocalizedStringKey(error.message)),
                    primaryButton: .default(Text(LocalizedStringKey("resend")), action: {
                        viewModel.resendLinkVerificationEmail()
                    }),
                    secondaryButton: .default(Text(LocalizedStringKey("cancel")), action: {
                        viewModel.uiState.error = nil
                    })
                )
            default:
                return Alert(
                title: Text(LocalizedStringKey(error.title)),
                message: Text(LocalizedStringKey(error.message)),
                dismissButton: .default(Text(LocalizedStringKey("Accept")), action: {
                    viewModel.uiState.error = nil
                })
            )
        }
    }
}
