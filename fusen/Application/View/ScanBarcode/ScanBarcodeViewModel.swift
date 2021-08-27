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
    private var scanningCode: String?
    private var scannedCode = Set<String>()
    private var lastScannedTime = Date(timeIntervalSince1970: 0)
    private let accountService: AccountServiceProtocol
    private let publicationRepository: PublicationRepository
    private let bookRepository: BookRepository

    @Published var isTorchOn: Bool = false
    @Published var suggestedBook: Publication?
    @Published var scannedBook: Publication?
    
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
        backCamera.torchMode = isTorchOn ? .off : .on
        backCamera.unlockForConfiguration()

        isTorchOn = currentTorch()
    }

    func onBarcodeScanned(code: String) async {
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
            scanningCode = code
            scannedCode.insert(code)

            do {
                let publication = try await publicationRepository.findBy(isbn: isbn)
                log.d("Found publication: \(publication)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.suggestedBook = publication
                }
            } catch {
                log.e(error.localizedDescription)
                isScanning = false
                ErrorHUD.show(message: .scanBarcode)
            }
        }
    }
    
    func onAcceptSuggestedBook(collection: Collection?) async {
        guard let user = accountService.currentUser else { return }
        guard isScanning else { return }
        guard let publication = suggestedBook else { return }
        
        scanningCode = nil
        suggestedBook = nil
        isScanning = false
    
        do {
            let id = try await bookRepository.addBook(of: publication, in: collection, for: user)
            log.d("Book is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.scannedBook = publication
                // 強制的に更新 -> Viewの再構築が発生するため注意
                NotificationCenter.default.postRefreshBookShelfAllCollection()

                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                    guard let self = self else { return }
                    self.scannedBook = nil
                }
            }
        } catch {
            log.e(error.localizedDescription)
            ErrorHUD.show(message: .addBook)
        }
    }
    
    func onDeclinSuggestedBook() async {
        scanningCode = nil
        suggestedBook = nil
        isScanning = false
    }
    
    private func currentTorch() -> Bool {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
            backCamera.hasTorch else { return false }
        return backCamera.torchMode == .on
    }
}
