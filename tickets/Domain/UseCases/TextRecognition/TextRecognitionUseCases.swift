import Vision

class TextRecognitionUseCases {
    // MARK: - Properties
    var mapper: RecognizedTextMapper

    // MARK: - Init
    init(mapper: RecognizedTextMapper) {
        self.mapper = mapper
    }

    // MARK: - Functions
    func process(this observations: [VNRecognizedTextObservation]) -> [TextRecognition] {
        return self.mapper.map(from: observations)
    }
}
