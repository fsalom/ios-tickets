//
//  DetailTicketView.swift
//  tickets
//
//  Created by Fernando Salom Carratala on 18/11/24.
//

import SwiftUI

struct DetailTicketView: View {
    @StateObject var viewModel: DetailTicketViewModel

    var body: some View {
        ScrollView {
            HStack {
                Image(.mercadonaLogo)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.gray)
                    .clipShape(Circle())
                Text(viewModel.uiState.ticket.location ?? " ").font(.footnote)
                Spacer()

            }
            ForEach(viewModel.uiState.ticket.products) { product in
                HStack {
                    Text("\(product.quantity)")
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color.black))
                    Text(product.name.lowercased())
                    Spacer()
                    Text("\(product.priceWithFormat)").bold()
                }
                .padding(4)
                Divider()
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle(viewModel.uiState.ticket.totalWithFormat)
    }
}

#Preview {
    DetailTicketBuilder().build(with: Ticket(id_ticket: "", products: [], total: 0.0, iva: 0.0, date: "", email: ""))
}
