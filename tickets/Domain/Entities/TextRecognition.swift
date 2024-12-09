import SwiftUI
import Vision

struct TextRecognition: Identifiable {
    let id: UUID = UUID()
    let text: String
    let confidence: Float
    let box: VNRectangleObservation

    init?(topCandidate: VNRecognizedText, boundingBox: CGRect) {
        guard let range = topCandidate.string.range(of: topCandidate.string),
              let boundingBox = try? topCandidate.boundingBox(for: range) else {
            return nil
        }
        self.text = topCandidate.string
        self.box = boundingBox
        self.confidence = topCandidate.confidence
    }

    enum TextRecognitionError: Error {
        case invalidBoundingBox
    }
}
