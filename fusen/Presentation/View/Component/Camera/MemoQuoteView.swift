//
//  MemoQuoteView.swift
//  MemoQuoteView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import CropViewController
import Domain
import SwiftUI

struct MemoQuoteView: UIViewControllerRepresentable {
    typealias Handler = (Result<ImageData, Error>) -> Void
    
    private let handler: Handler
    
    init(handler: @escaping Handler) {
        self.handler = handler
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coodinator {
        return Coordinator { image in
            if let imageData = ImageData(type: .memoQuote, uiImage: image) {
                handler(.success(imageData))
            }
        }
    }
}

extension MemoQuoteView {
    final class Coodinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
        private var handler: (UIImage) -> Void
        private var pickerVC: UIImagePickerController?
        
        init(handler: @escaping (UIImage) -> Void) {
            self.handler = handler
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                log.e("Unexpected error occured!")
                picker.dismiss(animated: true)
                return
            }
            
            pickerVC = picker
            
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            picker.present(cropViewController, animated: true)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            // 'image' is the newly cropped version of the original image
            handler(image)
            cropViewController.dismiss(animated: true) { [weak self] in
                self?.pickerVC?.dismiss(animated: true)
            }
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true) { [weak self] in
                self?.pickerVC?.dismiss(animated: true)
            }
        }
    }
}

struct MemoQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        MemoQuoteView { _ in }
    }
}
