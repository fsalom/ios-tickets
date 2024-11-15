//
//  DeleteAccountToast.swift
//  Gula
//
//  Created by Jorge on 29/10/24.
//

import SwiftUI

struct DeleteAccountToast: View {
    @State var showToast: Bool

    var body: some View {
        VStack {
            // TODO: It will have to be added to the HomeView or the LoginView in the destination APP
            if showToast {
                ToastView(isVisible: $showToast, message: "deleteAccountSuccess", isCloseButtonActive: true, textAlingment: .leading, textHorizontalPadding: 20, closeAction:  {
                    withAnimation(.easeInOut) {
                        showToast = false
                    }
                })
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut) {
                    showToast = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    DeleteAccountToast(showToast: true)
}
