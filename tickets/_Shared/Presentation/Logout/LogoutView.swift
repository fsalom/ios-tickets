//
//  LogoutView.swift
//  Gula
//
//  Created by Axel Pérez Gaspar on 29/8/24.
//

import SwiftUI

struct LogoutView: View {
    @ObservedObject var viewModel: LogoutViewModel

    var body: some View {
        VStack {
            Text("Usuario logueado con éxito")
            Button("Logout") {
                viewModel.logout()
            }

            NavigationLink(destination: ChangeEmailBuilder().build()) {
                Text("Change email")
            }
        }
    }
}

#Preview {
    LogoutBuilder().build()
}
