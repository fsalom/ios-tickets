//
//  HomeView.swift
//  tickets
//
//  Created by Fernando Salom Carratala on 16/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("Cerrar sesión") {
            Task {
                try? await Config.shared.authenticator.logout()
            }
        }
        List(viewModel.uiState.tickets, id: \.id) { ticket in
            NavigationLink {
                DetailTicketBuilder().build(with: ticket)
            } label: {
                HStack {
                    Image(.mercadonaLogo)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.gray)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("Mercadona")
                        Text("\(ticket.dateWithFormat)").font(.footnote)
                    }

                    Spacer()
                    Text("\(ticket.totalWithFormat)").bold()
                }                
            }

        }
        .listStyle(.plain)
        .onAppear() {
            viewModel.getAll()
            viewModel.checkAndRequestNotificationPermissionIfNecessary()
        }
    }
}

#Preview {
    HomeViewBuilder().build()
}
