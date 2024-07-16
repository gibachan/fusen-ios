//
//  ImagePicker.swift
//  ImagePicker
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Domain
import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    typealias Handler = (Result<ImageData, Error>) -> Void
    enum PickerType {
        case camera
        case photoLibrary
    }
    
    private let imageType: ImageData.ImageType
    private let pickerType: PickerType
    private let handler: Handler
    
    init(imageType: ImageData.ImageType, pickerType: PickerType, _ handler: @escaping Handler) {
        self.imageType = imageType
        self.pickerType = pickerType
        self.handler = handler
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        switch pickerType {
        case .camera:
            controller.sourceType = .camera
        case .photoLibrary:
            controller.sourceType = .photoLibrary
        }
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
    
    func makeCoordinator() -> Coodinator {
        return Coordinator { image in
            if let imageData = ImageData(type: imageType, uiImage: image) {
                handler(.success(imageData))
            }
        }
    }
}

extension ImagePickerView {
    final class Coodinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private var handler: (UIImage) -> Void
        
        init(handler: @escaping (UIImage) -> Void) {
            self.handler = handler
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                handler(image)
            }
            picker.dismiss(animated: true)
        }
    }
}
