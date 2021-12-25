//
//  AddCollectionViewModel.swift
//  AddCollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import Foundation

final class AddCollectionViewModel: ObservableObject {
    private let getCollectionsUseCase: GetCollectionsUseCase
    private let addCollectionUseCase: AddCollectionUseCase
    
    @Published var isCollectionCountOver = false
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    
    init(
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl(),
        addCollectionUseCase: AddCollectionUseCase = AddCollectionUseCaseImpl()
    ) {
        self.getCollectionsUseCase = getCollectionsUseCase
        self.addCollectionUseCase = addCollectionUseCase
    }
    
    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let collections = try await getCollectionsUseCase.invoke()
            state = .collectionsLoaded
            isCollectionCountOver = collections.count >= Collection.countLimit
        } catch {
            log.e(error.localizedDescription)
            state = .failed
        }
    }
    
    @MainActor
    func onNameChange(_ name: String) {
        isSaveEnabled = !isCollectionCountOver && !name.isEmpty
    }
    
    @MainActor
    func onSave(
        name: String,
        color: RGB
    ) async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            log.d("Saving \(name) collection with \(color)")
            let id = try await addCollectionUseCase.invoke(name: name, color: color)
            log.d("Collection is added for id: \(id.value)")
            state = .collectionAdded
        } catch AddCollectionUseCaseError.countOver {
            log.e("collection count limit over")
            state = .collectionCountOver
        } catch {
            log.e(error.localizedDescription)
            state = .failed
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
