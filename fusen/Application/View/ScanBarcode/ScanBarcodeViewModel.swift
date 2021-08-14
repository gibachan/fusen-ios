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
    private let accountService: AccountServiceProtocol
    private let publicationRepository: PublicationRepository
    private let bookRepository: BookRepository

    @Published var isTorchOn: Bool = false
    
    init(accountService: AccountServiceProtocol = AccountService.shared,
         publicationRepository: PublicationRepository = PublicationRepositoryImpl(),
         bookRepository: BookRepository = BookRepositoryImpl()) {
        self.accountService = accountService
        self.publicationRepository = publicationRepository
        self.bookRepository = bookRepository
        self.isTorchOn = currentTorch()
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
        guard let user = accountService.currentUser else { return }
        guard !isScanning else { return }
        guard !scannedCode.contains(code) else {
            log.d("code=\(code) has benn already scanned")
            return
        }
        guard let isbn = ISBN.from(code: code) else { return }
        
        let now = Date()
        if now.timeIntervalSince(lastScannedTime) >= scanInterval {
            isScanning = true
            lastScannedTime = now
            scannedCode.insert(code)
            do {
                let publication = try await publicationRepository.findBy(isbn: isbn)
                log.d("Found publication: \(publication)")
                let id = try await bookRepository.addBook(of: publication, for: user)
                log.d("Book is added for id: \(id.value)")
            } catch {
                // FIXME: error handling
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
