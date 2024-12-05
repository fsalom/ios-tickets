import Foundation
import SwiftUI
import VisionKit
import Vision

class PreviewerViewModel: NSObject, ObservableObject {
    @Published var imageArray: [UIImage] = []
    @Published var errorMessage: String?
    @Published var image: UIImage?
    @Published var observations: [TextRecognition] = []

    var textRecognitionUseCases: TextRecognitionUseCases

    init(textRecognitionUseCases: TextRecognitionUseCases) {
        self.textRecognitionUseCases = textRecognitionUseCases
    }


    func calculatePosition(for point: CGPoint, and reader: GeometryProxy) -> CGPoint {
        let x = (point.x * reader.size.width)
        let y = reader.size.height - (point.y * reader.size.height)
        return CGPoint(x: x, y: y)
    }
}

extension PreviewerViewModel: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        self.observations.removeAll()
        self.imageArray.removeAll()
        for i in 0..<scan.pageCount {
            self.imageArray.append(scan.imageOfPage(at:i))
        }

        let textRecognitionFunction = performTextRecognition { observations -> [String] in
            self.observations = self.textRecognitionUseCases.process(this: observations)
            return []
        }

        guard let image = imageArray.first else {
            return
        }
        let _ = textRecognitionFunction(image)
        self.image = image

        controller.dismiss(animated: true, completion: nil)
    }
}
