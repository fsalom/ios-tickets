//
//  SuccessView.swift
//  Gula
//
//  Created by Jorge Planells Zamora on 18/7/24.
//

import SwiftUI

struct SuccessView: View {
    @ObservedObject var viewModel: SuccessViewModel
    @Environment(\.presentationMode) var presentation
    @State private var showAlert = false
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    
    var config: SuccesConfig
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                Text("Gula")
                    .font(.system(size: 20))
                    .bold()
                    .padding(.top, 18)
                Image(systemName: "pencil")
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.gray)
                    )
                VStack(spacing: 35) {
                    Text(LocalizedStringKey(config.title))
                        .font(.system(size: 20))
                        .bold()
                    Text(config.message)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 34)
                        .font(.system(size: 18))
                    VStack(spacing: 0) {
                        Text("emailNotReceived")
                            .font(.system(size: 14))
                        Button {
                            switch config.messageType {
                            case .changeEmail:
                                if let email = config.parameter {
                                    viewModel.change(email: email)
                                }
                            case .recoverPassword:
                                presentation.wrappedValue.dismiss()
                            }
                        } label: {
                            Text("sendAgain")
                                .font(.system(size: 14))
                                .bold()
                                .foregroundStyle(.black)
                                .underline()
                        }
                    }
                }
                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.uiState.error, {
            _, error in
            guard let error else { return }
            errorAlertTitle = LocalizedStringKey(error.title)
            errorAlertMessage = LocalizedStringKey(error.message)
            showAlert = true
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text(errorAlertTitle), message: Text(errorAlertMessage), dismissButton: .default(Text("Accept"), action: {
                viewModel.uiState.error = nil
            }))
        }
        .overlay {
            if viewModel.uiState.hasEmailBeenSent {
                VStack {
                    ToastView(isVisible: $viewModel.uiState.hasEmailBeenSent, message: "changeEmailSent", isCloseButtonActive: true, textAlingment: .leading, closeAction:  {
                        withAnimation(.easeInOut) {
                            viewModel.uiState.hasEmailBeenSent = false
                        }
                    })
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation(.easeInOut) {
                                viewModel.uiState.hasEmailBeenSent = false
                            }
                        }
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

#Preview {
    let config = SuccesConfig(title: "changeEmailTitle",
                              message:  "changeDescription",
                              parameter: nil,
                              messageType: .changeEmail)
    SuccessBuilder().build(with: config)
}
