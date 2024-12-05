class PreviewerBuilder {
    func build() -> PreviewerView {
        let textRecognitionUseCases = TextRecognitionUseCases(mapper: RecognizedTextMapper())
        let viewModel = PreviewerViewModel(textRecognitionUseCases: textRecognitionUseCases)
        let view = PreviewerView(viewModel: viewModel)
        return view
    }
}
