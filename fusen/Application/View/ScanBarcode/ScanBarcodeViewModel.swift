//
//  ScanBarcodeViewModel.swift
//  ScanBarcodeViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import AVFoundation
import Foundation

final class ScanBarcodeViewModel: ObservableObject {
    private let scanInterval: Double = 1.0
    private var isScanning = false
    private var scannedCode = Set<String>()
    private var lastScannedTime = Date(timeIntervalSince1970: 0)
    private let publicationRepository: PublicationRepository

    @Published var isTorchOn: Bool = false
    
    init(publicationRepository: PublicationRepository = PublicationRepositoryImpl()) {
        self.publicationRepository = publicationRepository
        isTorchOn = currentTorch()
    }
    
    func onTorchToggled() {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
            backCamera.hasTorch else { return }
        try? backCamera.lockForConfiguration()
        backCamera.torchMode = isTorchOn ? .on : .off
        backCamera.unlockForConfiguration()
        
        isTorchOn = currentTorch()
    }

    func onBarcodeScanned(code: String) async {
        guard !isScanning else { return }
        guard !scannedCode.contains(code) else { print("#passed"); return }
        guard let isbn = ISBN.from(code: code) else { return }
        
        let now = Date()
        if now.timeIntervalSince(lastScannedTime) >= scanInterval {
            isScanning = true
            lastScannedTime = now
            scannedCode.insert(code)
            do {
                let publication = try await publicationRepository.findBy(isbn: isbn)
                print("Publication found: \(publication)")
            } catch {
                print(error.localizedDescription)
            }
            isScanning = false
        }
    }
    
    private func currentTorch() -> Bool {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
            backCamera.hasTorch else { return false }
        return backCamera.torchMode == .on
    }
}
