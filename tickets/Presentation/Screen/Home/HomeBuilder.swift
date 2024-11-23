class HomeViewBuilder {
    func build() -> HomeView {
        let ticketsUseCases = TicketsContainer().makeUseCases()
        let fcmUseCases = FCMContainer().makeUseCases()
        let userUseCases = UserContainer().makeUseCases()
        let viewModel = HomeViewModel(
            ticketsUseCase: ticketsUseCases,
            fcmUseCases: fcmUseCases,
            userUseCases: userUseCases
        )
        let view = HomeView(viewModel: viewModel)
        return view
    }
}
