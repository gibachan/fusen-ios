//
//  ScanBarcodeViewModel.swift
//  ScanBarcodeViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import AVFoundation
import Foundation

@MainActor
final class ScanBarcodeViewModel: ObservableObject {
    private let scanInterval: Double = 1.0
    private var isScanning = false
    private var scanningCode: String?
    private var scannedCode = Set<String>()
    private var lastScannedTime = Date(timeIntervalSince1970: 0)
    private let analyticsService: AnalyticsServiceProtocol
    private let searchPublicationByBarcodeUseCase: SearchPublicationByBarcodeUseCase
    private let addBookByPublicationUseCase: AddBookByPublicationUseCase

    @Published var isTorchOn: Bool = false
    @Published var suggestedBook: Publication?
    @Published var scannedBook: Publication?
    
    init(
        analyticsService: AnalyticsServiceProtocol = AnalyticsService.shared,
        searchPublicationByBarcodeUseCase: SearchPublicationByBarcodeUseCase = SearchPublicationByBarcodeUseCaseImpl(),
        addBookByPublicationUseCase: AddBookByPublicationUseCase = AddBookByPublicationUseCaseImpl()
    ) {
        self.analyticsService = analyticsService
        self.searchPublicationByBarcodeUseCase = searchPublicationByBarcodeUseCase
        self.addBookByPublicationUseCase = addBookByPublicationUseCase
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
                let result = try await searchPublicationByBarcodeUseCase.invoke(barcode: code)
                switch result {
                case let .foundByRakutenBooks(publication: publication):
                    log.d("Found publication by Rakuten Books API: \(publication)")
                    suggestedBook = publication
                case let .foundByGoogleBooks(publication: publication):
                    log.d("Found publication by Google Books API: \(publication)")
                    suggestedBook = publication
                }
            } catch {
                log.e("Not Found Book for \(isbn): \(error.localizedDescription)")
                isScanning = false
                ErrorHUD.show(message: .scanBarcode)
            }
        }
    }
    
    func onAcceptSuggestedBook(collection: Collection?) async {
        guard isScanning else { return }
        guard let publication = suggestedBook else { return }
        
        scanningCode = nil
        suggestedBook = nil
        isScanning = false
    
        do {
            let id = try await addBookByPublicationUseCase.invoke(publication: publication, collection: collection)
            log.d("Book is added for id: \(id.value)")
            scannedBook = publication
            // 強制的に更新 -> Viewの再構築が発生するため注意
            NotificationCenter.default.postRefreshBookShelfAllCollection()
            analyticsService.log(event: .addBookByBarcode)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.scannedBook = nil
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
