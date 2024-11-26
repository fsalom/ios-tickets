import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
            ScrollView {
                VStack {
                    HStack{
                        VStack(alignment: .leading) {
                            Text("Hola ") + Text("Fer").fontWeight(.black)

                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                    
                    HStack {
                        VStack{
                            Text("328,57€")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Tus gastos este mes")
                                .font(.footnote)
                                .fontWeight(.regular)
                            ChartExampleView(tickets: viewModel.uiState.tickets)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 32)
                    .foregroundStyle(Color.black)
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

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
                }
                Spacer()
        }
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Settings tapped")
                }) {
                    Text("FS")
                        .font(.footnote)
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .foregroundStyle(Color.black)
                        .clipShape(Circle())

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
