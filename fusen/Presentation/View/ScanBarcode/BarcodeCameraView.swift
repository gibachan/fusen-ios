//
//  BarcodeCameraView.swift
//  BarcodeCameraView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import AVFoundation
import SwiftUI
import UIKit

struct BarcodeCameraView: UIViewRepresentable {
    typealias UIViewType = CameraPreview
    typealias Handler = (String) -> Void

    private let handler: Handler

    init(_ handler: @escaping Handler) {
        self.handler = handler
    }

    func makeUIView(context: UIViewRepresentableContext<BarcodeCameraView>) -> BarcodeCameraView.UIViewType {
        let cameraView = CameraPreview()
        #if targetEnvironment(simulator)
        cameraView.setupForSimulator()
        #else
        cameraView.setup()
        #endif
        cameraView.delegate = context.coordinator
        return cameraView
    }

    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<BarcodeCameraView>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(handler: handler)
    }
}

extension BarcodeCameraView {
    final class Coordinator: NSObject, CameraPreviewDelegate {
        private var handler: Handler

        init(handler: @escaping Handler) {
            self.handler = handler
        }

        func cameraPreviewDidDetectBarcode(code: String) {
            handler(code)
        }
    }
}
