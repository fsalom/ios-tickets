import Vision

struct RecognizedTextMapper {
    func map(from observations: [VNRecognizedTextObservation]) -> [TextRecognition] {
        return observations.compactMap { observation in
            guard let topCandidate = observation.topCandidates(1).first else { return nil }
            return TextRecognition(
                topCandidate: topCandidate,
                boundingBox: observation.boundingBox
            )
        }
    }
}
