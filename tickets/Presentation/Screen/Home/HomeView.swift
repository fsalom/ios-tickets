import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var selectedTab: Int = 0

    var body: some View {
        if viewModel.uiState.loading {
            ProgressView()
                .onAppear {
                    viewModel.getTicketsPerMonth()
                    viewModel.checkAndRequestNotificationPermissionIfNecessary()
                }
        } else {
            ScrollView {
                VStack {
                    headerView
                    tabView
                    ticketsListView
                }
                Spacer()
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsButton
                }
            }
        }
    }

    // Subvista para el encabezado
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hola ") + Text("Fer").fontWeight(.black)
                Text("Tus gastos siempre al día")
                    .font(.footnote)
            }
            Spacer()
        }
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }

    // Subvista para el TabView
    private var tabView: some View {
        TabView(selection: $selectedTab) {
            ForEach(viewModel.uiState.ticketsPerMonths.indices, id: \.self) { index in
                TabExpensesMonthView(ticketsPerMonth: viewModel.uiState.ticketsPerMonths[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 180)
        .onChange(of: selectedTab) { viewModel.changeMonth(index: $0) }
    }

    // Subvista para la lista de tickets
    private var ticketsListView: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.uiState.ticketsOfMonth.indices, id: \.self) { index in
                TicketRow(ticket: viewModel.uiState.ticketsOfMonth[index])
                if index != (viewModel.uiState.ticketsOfMonth.count - 1) {
                    Divider()
                }
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

    // Subvista para el botón de ajustes
    private var settingsButton: some View {
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


#Preview {
    HomeViewBuilder().build()
}
