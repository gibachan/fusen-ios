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
        guard let isbn = ISBN.from(code: code) else {
            return
        }
        
        let now = Date()
        if now.timeIntervalSince(lastScannedTime) >= scanInterval {
            lastScannedTime = now
            do {
                let publication = try await publicationRepository.findBy(isbn: isbn)
                print("Publication found: \(publication)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func currentTorch() -> Bool {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
            backCamera.hasTorch else { return false }
        return backCamera.torchMode == .on
    }
}
