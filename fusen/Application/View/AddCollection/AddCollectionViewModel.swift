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
    
    @Published var isCollectionCountOver = false
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let collections = try await collectionRepository.getlCollections(for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .collectionsLoaded
                self.isCollectionCountOver = collections.count >= Collection.countLimit
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    func onNameChange(_ name: String) {
        isSaveEnabled = !isCollectionCountOver && !name.isEmpty
    }
    
    func onSave(
        name: String,
        color: RGB
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        // Check collection count
        do {
            let collections = try await collectionRepository.getlCollections(for: user)
            log.d("Current collection count: \(collections.count)")
            if collections.count >= Collection.countLimit {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.state = .failed
                }
                return
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
        
        state = .loading
        do {
            log.d("Saving \(name) collection with \(color)")
            let id = try await collectionRepository.addCollection(name: name, color: color, for: user)
            log.d("Collection is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .collectionAdded
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case collectionsLoaded
        case collectionAdded
        case failed
        case collectionCountOver
        
        var isInProgress: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }

}
