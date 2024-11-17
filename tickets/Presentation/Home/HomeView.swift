//
//  HomeView.swift
//  tickets
//
//  Created by Fernando Salom Carratala on 16/11/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("Cerrar sesión") {
            Task {
                try? await Config.shared.authenticator.logout()
            }
        }
        List(viewModel.uiState.tickets) { tickets in
            Text("\(tickets.total)€")
        }.onAppear {
            viewModel.getAll()
        }
    }
}

#Preview {
    HomeViewBuilder().build()
}
