import SwiftUI

struct DetailTicketView: View {
    @StateObject var viewModel: DetailTicketViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(.mercadonaLogo)
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color.gray)
                        .clipShape(Circle())
                    VStack{
                        Text(viewModel.uiState.ticket.location ?? "").font(.footnote)
                    }
                    Spacer()
                }
                Divider()
                    .padding(.horizontal, 64)
                    .padding(.vertical, 8)
                HStack{
                    Text(viewModel.uiState.ticket.dateWithFormat).font(.footnote)
                    Spacer()
                    Text(viewModel.uiState.ticket.totalWithFormat)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(8)
                Divider()
                    .padding(.horizontal, 64)
                    .padding(.vertical, 8)
                ForEach(viewModel.uiState.ticket.products) { product in
                    HStack {
                        Text("\(product.quantity) x \(product.name.lowercased())")
                        Spacer()
                        Text("\(product.priceWithFormat)").bold()
                    }
                    .padding(4)
                    //Divider()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16.0)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
            )
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 16)
        .navigationTitle(viewModel.uiState.ticket.totalWithFormat)
    }
}

#Preview {
    DetailTicketBuilder().build(with: Ticket(id_ticket: "", products: [], total: 0.0, iva: 0.0, date: "", email: ""))
}
