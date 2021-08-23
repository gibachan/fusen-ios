//
//  ImagePicker.swift
//  ImagePicker
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    typealias Handler = (Result<ImageData, Error>) -> Void
    enum PickerType {
        case camera
        case photoLibrary
    }
    
    private let type: PickerType
    private let handler: Handler
    
    init(type: PickerType, _ handler: @escaping Handler) {
        self.type = type
        self.handler = handler
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        switch type {
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
        return Coordinator(handler: handler)
    }
}

extension ImagePickerView {
    final class Coodinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private var handler: Handler
        
        init(handler: @escaping Handler) {
            self.handler = handler
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage,
               let thumbnail = ImageData(uiImage: image){
                handler(.success(thumbnail))
            }
            picker.dismiss(animated: true)
        }
    }
}
