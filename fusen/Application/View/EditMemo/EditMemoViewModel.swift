//
//  EditMemoViewModel.swift
//  EditMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

final class EditMemoViewModel: ObservableObject {
    private let imageCountLimit = 1
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var memo: Memo
    @Published var imageResults: [DocumentCameraView.ImageResult] = []
    @Published var memoImages: [EditMemoImage] = []
    
    init(
        memo: Memo,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.memo = memo
        self.accountService = accountService
        self.memoRepository = memoRepository
        
        self.isSaveEnabled = !memo.text.isEmpty
        self.memoImages = memo.imageURLs.enumerated().map { index, url in
            EditMemoImage(position: index, type: .url(url))
        }
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onMemoImageAdd(images: [DocumentCameraView.ImageResult]) {
        imageResults = Array(images.prefix(imageCountLimit))
    }
    
    func onMemoImageDelete(image: DocumentCameraView.ImageResult) {
        imageResults = imageResults.filter { $0.id != image.id }
    }
    
    func onSave(
        text: String,
        quote: String,
        page: Int,
        imageURLs: [URL]
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
            try await memoRepository.update(memo: memo, text: text, quote: quote, page: memoPage, imageURLs: imageURLs, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
                NotificationCenter.default.postError(message: .editMemo)
            }
        }
    }
    
    func onDelete() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await memoRepository.delete(memo: memo, for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .deleted
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
                NotificationCenter.default.postError(message: .deleteMemo)
            }
        }
    }
    
    enum EditMemoImageType: Hashable {
        case url(URL)
        case memory
    }
    
    struct EditMemoImage: Identifiable, Hashable {
        let position: Int
        let type: EditMemoImageType
        
        var id: Int { position }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case deleted
        case failed
        
        var isInProgress: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}
