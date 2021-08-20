//
//  DocumentCameraView.swift
//  DocumentCameraView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import SwiftUI
import VisionKit

struct DocumentCameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = VNDocumentCameraViewController
    typealias Handler = (Result<[ImageResult], Error>) -> Void
    
    private let handler: Handler
    
    init(_ handler: @escaping Handler) {
        self.handler = handler
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(handler: handler)
    }
}

extension DocumentCameraView {
    struct ImageResult: Identifiable {
        var id: Int { page }
        let page: Int
        let image: UIImage
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private var handler: Handler
        
        init(handler: @escaping Handler) {
            self.handler = handler
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            log.e(error.localizedDescription)
            handler(.failure(error))
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var images: [ImageResult] = []
            for i in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: i)
                images.append(ImageResult(page: i, image: image))
            }
            handler(.success(images))
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

struct DocumentCameraView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentCameraView { _ in }
    }
}
