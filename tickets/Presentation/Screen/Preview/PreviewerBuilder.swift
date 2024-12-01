class PreviewerBuilder {
    func build() -> PreviewerView {
        let viewModel = PreviewerViewModel()
        let view = PreviewerView(viewModel: viewModel)
        return view
    }
}
