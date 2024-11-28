import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var selectedTab: Int = 0

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
                TabView(selection: $selectedTab) {
                    ForEach(viewModel.uiState.ticketsPerMonths.indices, id: \.self) { index in
                        TabExpensesMonthView(ticketsPerMonth: viewModel.uiState.ticketsPerMonths[index])
                                .tag(index)
                        }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 300)
                .onChange(of: selectedTab) {
                    viewModel.changeMonth(index: selectedTab)
                }
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.uiState.ticketsOfMonth) { ticket in
                        TicketRow(ticket: ticket)
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
            viewModel.getTicketsPerMonth()
            viewModel.checkAndRequestNotificationPermissionIfNecessary()
        }
    }
}

#Preview {
    HomeViewBuilder().build()
}
