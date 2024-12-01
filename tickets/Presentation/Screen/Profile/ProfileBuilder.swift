class ProfileBuilder {
    func build() -> ProfileView {
        let viewModel = ProfileViewModel()
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}
