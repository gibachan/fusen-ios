//
//  AddMemoViewModel.swift
//  AddMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation
import VisionKit

final class AddMemoViewModel: NSObject, ObservableObject {
    private let imageCountLimit = 1
    private let book: Book
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var imageResults: [ImageResult] = []
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onSave(
        text: String,
        quote: String,
        page: Int,
        imageURLs: [URL]
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isLoading else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
            let image: MemoImage? = imageResults
                .compactMap { MemoImage(uiImage: $0.image) }
                .first
            let id = try await memoRepository.addMemo(of: book, text: text, quote: quote, page: memoPage, image: image, for: user)
            log.d("Memo is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onMemoImageDelete(image: ImageResult) {
        imageResults = imageResults.filter { $0.id != image.id }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
        
        var isLoading: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }

    struct ImageResult: Identifiable {
        var id: Int { page }
        let page: Int
        let image: UIImage
    }
}

extension AddMemoViewModel: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        log.e(error.localizedDescription)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        imageResults = []
        for i in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: i)
            imageResults.append(ImageResult(page: i, image: image))
        }
        imageResults = Array(imageResults.prefix(imageCountLimit))
        controller.dismiss(animated: true, completion: nil)
    }
}
