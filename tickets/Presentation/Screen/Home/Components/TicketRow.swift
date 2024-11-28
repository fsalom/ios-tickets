import SwiftUI

struct TicketRow: View {
    let ticket: Ticket

    var body: some View {
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
                        .font(.body)
                    Text("\(ticket.dateWithFormat)")
                        .font(.footnote)
                }
                Spacer()
                Text("\(ticket.totalWithFormat)")
                    .font(.body)
                    .bold()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.gray)
            }
        }
        .buttonStyle(.plain)
    }
}
