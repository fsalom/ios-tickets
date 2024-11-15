//
//  FakeViewForChangeEmailConfirmationView.swift
//  Gula
//
//  Created by Jorge Miguel on 6/11/24.
//

import SwiftUI

struct FakeViewToShowToastOfAccountChangeView: View {
    @EnvironmentObject var deeplinkManager: DeepLinkManager
    @StateObject var viewModel: FakeViewToShowToastOfAccountChangeViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        VStack {
            Text("Fake View")
                .font(.title)
                .padding()
                .onAppear {
                    switch viewModel.typeChange {
                    case .email:
                        viewModel.uiState.hasEmailChanged = true
                    case .password:
                        viewModel.uiState.hasPasswordChanged = true
                    }
                }
                .onDisappear {
                    if viewModel.typeChange == .email {
                        deeplinkManager.screen = .none
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            VStack {
                showToast(typeChange: viewModel.typeChange)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeInOut) {
                        switch viewModel.typeChange {
                        case .email:
                            viewModel.uiState.hasEmailChanged = false
                        case .password:
                            viewModel.uiState.hasPasswordChanged = false
                        }
                    }
                }
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Fake View")
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
    }

    func showToast(typeChange: AccountParamChange) -> ToastView {
        switch typeChange {
        case .email:
            ToastView(isVisible: $viewModel.uiState.hasEmailChanged, message: "emailProperlyUpdated", isCloseButtonActive: true, textAlingment: .leading, closeAction:  {
                withAnimation(.easeInOut) {
                    viewModel.uiState.hasEmailChanged = false
                }
            })
        case .password:
            ToastView(isVisible: $viewModel.uiState.hasPasswordChanged, message: "passwordProperlyUpdated", isCloseButtonActive: true, textAlingment: .leading, closeAction:  {
                withAnimation(.easeInOut) {
                    viewModel.uiState.hasPasswordChanged = false
                }
            })
        }
    }
}
