import Vision

protocol TextRecognitionLocalDataSourceProtocol {
    func process(this observations: [VNRecognizedTextObservation]) async throws -> [TextRecognition]
}
