//
//  RegisterConfirmationScreen.swift
//  Gula
//
//  Created by María on 1/8/24.
//

import SwiftUI

struct RegisterConfirmationView: View {
    @EnvironmentObject var deeplinkManager: DeepLinkManager
    @ObservedObject var viewModel: RegisterConfirmationViewModel
    @Environment(\.presentationMode) var presentation
    @State private var toastTimer: Timer?
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var isShowingAlert = false
    @State private var isShowingToast = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                ZStack {
                    Text("gulaTitle")
                        .font(.system(size: 20))
                    HStack {
                        Spacer()
                        Button {
                            //TODO: Dismiss to be removed once modules are installed
                            presentation.wrappedValue.dismiss()
                            deeplinkManager.screen = .home
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                        .padding(.trailing, 11)
                    }
                }
                .padding(.top, 18)
                Image(systemName: "pencil")
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.gray)
                    )
                
                VStack(spacing: 35) {
                    Text("confirmEmailTitle")
                        .font(.system(size: 20))
                    Text("emailSentInfoRegister, \(viewModel.email)")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 34)
                        .font(.system(size: 18))
                    VStack(spacing: 0) {
                        Text("emailNotReceived")
                            .font(.system(size: 14))
                        Button {
                            viewModel.resendVerificationEmail()
                        } label: {
                            Text("sendAgain")
                                .font(.system(size: 14))
                                .foregroundStyle(.black)
                                .underline()
                        }
                    }
                }
                Spacer()
                if isShowingToast {
                    ToastView(isVisible: $isShowingToast,
                              message: "linkSent",
                              isCloseButtonActive: true,
                              closeAction: {
                        isShowingToast = false
                        toastTimer?.invalidate()
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(0)
                    .onAppear {
                        startToastTimer()
                    }
                }
            }
            .onChange(of: viewModel.uiState.sendEmailSucceeded, { _, _ in
                isShowingToast = true
            })
            .onChange(of: viewModel.uiState.error, { _, error in
                guard let error = error else { return }
                errorAlertTitle = LocalizedStringKey(error.title)
                errorAlertMessage = LocalizedStringKey(error.message)
                isShowingAlert = true
            })
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(errorAlertTitle), message: Text(errorAlertMessage), dismissButton: .default(Text("Accept"), action: {
                    if errorAlertTitle == "conectionError" {
                        viewModel.resendVerificationEmail()
                    }
                    viewModel.uiState.error = nil
                }))
            }
            .animation(.easeInOut, value: viewModel.uiState.sendEmailSucceeded)
            .toolbar(.hidden, for: .navigationBar)
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func startToastTimer() {
        toastTimer?.invalidate()
        toastTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            isShowingToast = false
        }
    }
}

#Preview {
    RegisterConfirmationBuilder().build(with: "test@email.com")
}
