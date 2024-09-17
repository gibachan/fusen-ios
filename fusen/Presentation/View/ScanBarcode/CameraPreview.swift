//
//  CameraPreview.swift
//  CameraPreview
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import AVFoundation
import UIKit

protocol CameraPreviewDelegate: AnyObject {
    func cameraPreviewDidDetectBarcode(code: String)
}

class CameraPreview: UIView {
    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var label: UILabel?

    // 読み取り範囲
    private let detectionX: CGFloat = 0.1
    private let detectionY: CGFloat = 0.4
    private let detectionWidth: CGFloat = 0.8
    private let detectionHeight: CGFloat = 0.2
    private var detectionAreaView: UIView?

    weak var delegate: CameraPreviewDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            label?.frame = self.bounds
        #else
            previewLayer?.frame = self.bounds
        #endif
        detectionAreaView?.frame = CGRect(x: frame.size.width * detectionX, y: frame.size.height * detectionY, width: frame.size.width * detectionWidth, height: frame.size.height * detectionHeight)
    }
}

extension CameraPreview {
    func setup() {
        let isCameraAuthorized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        if isCameraAuthorized {
            setupCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera()
                    }
                }
            }
        }
    }

    private func setupCamera() {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
        session.sessionPreset = .photo

        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13]
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            // 読み取り範囲を指定
            metadataOutput.rectOfInterest = CGRect(x: detectionY, y: 1 - detectionX - detectionWidth, width: detectionHeight, height: detectionWidth)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer

        // 読み取り範囲の枠を表示
        let detectionAreaView = UIView()
        detectionAreaView.layer.borderColor = UIColor.white.cgColor
        detectionAreaView.layer.borderWidth = 2
        addSubview(detectionAreaView)
        self.detectionAreaView = detectionAreaView

        session.startRunning()
    }

    func setupForSimulator() {
        self.label = UILabel(frame: self.bounds)
        if let label = self.label {
            label.text = "Click here to simulate scanning barcode"
            label.textColor = .white
            label.textAlignment = .center
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }

    @objc private func onClick() {
        delegate?.cameraPreviewDidDetectBarcode(code: "9784102122044")
    }
}

extension CameraPreview: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let value = readableObject.stringValue else { return }

        log.d("metadataObjects: \(metadataObjects.count) found!! \(value)")

        delegate?.cameraPreviewDidDetectBarcode(code: value)
    }
}
