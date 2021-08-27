//
//  AddCollectionViewModel.swift
//  AddCollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import Foundation

final class AddCollectionViewModel: ObservableObject {
    private let collectionCountLimit = 10
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    func onNameChange(_ name: String) {
        isSaveEnabled = !name.isEmpty
    }
    
    func onSave(
        name: String,
        color: RGB
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            log.d("Saving \(name) collection with \(color)")
            let id = try await collectionRepository.addCollection(name: name, color: color, for: user)
            log.d("Collection is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .succeeded
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
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
