import Vision

protocol TextRecognitionRepositoryProtocol {
    func process(this observations: [VNRecognizedTextObservation]) async throws -> [TextRecognition]
}
