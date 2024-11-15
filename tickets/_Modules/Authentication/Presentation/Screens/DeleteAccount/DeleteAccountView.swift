//
//  DeleteAccountView.swift
//  Gula
//
//  Created by Jorge on 29/10/24.
//

import SwiftUI

enum ActiveAlert: Identifiable {
    case deleteConfirmation
    case error

    var id: Int {
        hashValue
    }
}

struct DeleteAccountView: View {
    @ObservedObject var viewModel: DeleteAccountViewModel
    @State private var errorAlertTitle: LocalizedStringKey = ""
    @State private var errorAlertMessage: LocalizedStringKey = ""
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        VStack {
            Button {
                activeAlert = .deleteConfirmation
            } label: {
                Text("Delete account")
            }
        }
        .onChange(of: viewModel.uiState.error, { _, error in
            guard let error else { return }
            errorAlertTitle = LocalizedStringKey(error.title)
            errorAlertMessage = LocalizedStringKey(error.message)

            activeAlert = .error
        })
        .alert(item: $activeAlert) { alert in
            switch alert {
                case .deleteConfirmation:
                    return Alert(
                        title: Text(LocalizedStringKey("deleteAccountTitle")),
                        message: Text(LocalizedStringKey("deleteAccountMessage")),
                        primaryButton: .default(Text(LocalizedStringKey("cancel")), action: {
                            activeAlert = nil
                        }),
                        secondaryButton: .destructive(Text(LocalizedStringKey("delete")), action: {
                            viewModel.deleteAccount()
                        })
                    )
                case .error:
                    return Alert(
                        title: Text(errorAlertTitle),
                        message: Text(errorAlertMessage),
                        dismissButton: .default(Text("Accept"), action: {
                            viewModel.uiState.error = nil
                            activeAlert = nil
                        })
                    )
            }
        }
        .navigationDestination(isPresented: $viewModel.uiState.navigateToHome) {
            DeleteAccountToast(showToast: true)
        }
    }
}
