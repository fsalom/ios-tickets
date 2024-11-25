import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                HStack{
                    VStack(alignment: .leading) {
                        Text("324€")
                            .font(.title)
                            .bold()
                        Text("Gastado este mes")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .padding(16)
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.uiState.tickets) { ticket in
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
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Mi cesta")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Settings tapped")
                }) {
                    Image(systemName: "gearshape")
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    print("Profile tapped")
                }) {
                    Image(systemName: "person.crop.circle")
                }
            }
        }
        .onAppear {
            viewModel.getAll()
            viewModel.checkAndRequestNotificationPermissionIfNecessary()
        }
    }
}

#Preview {
    HomeViewBuilder().build()
}
