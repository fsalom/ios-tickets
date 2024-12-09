import Vision

class TextRecognitionRepository: TextRecognitionRepositoryProtocol {
    // MARK: - Properties
    private let local: TextRecognitionLocalDataSourceProtocol

    // MARK: - Init
    init(local: TextRecognitionLocalDataSourceProtocol) {
        self.local = local
    }

    func process(this observations: [VNRecognizedTextObservation]) async throws -> [TextRecognition] {
        return []
    }
}
