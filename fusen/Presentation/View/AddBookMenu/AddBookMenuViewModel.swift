//
//  AddBookMenuViewModel.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2021/09/17.
//

import Data
import Domain
import Foundation

final class AddBookMenuViewModel: ObservableObject {
    private let initialCollection: Domain.Collection?
    private let getCollectionsUseCase: GetCollectionsUseCase
    private var isGetCollectionFinished = false
    
    @Published var collections: [Domain.Collection] = []
    @Published var selectedCollection: Domain.Collection?
    
    init(
        initialCollection: Domain.Collection?,
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl(accountService: AccountService.shared, collectionRepository: CollectionRepositoryImpl())
    ) {
        self.initialCollection = initialCollection
        self.getCollectionsUseCase = getCollectionsUseCase
    }
    
    @MainActor
    func onAppear() async {
        guard !isGetCollectionFinished else { return }
        do {
            collections = try await getCollectionsUseCase.invoke()
            if let initialCollection = initialCollection,
               collections.contains(where: { $0 == initialCollection }) {
                selectedCollection = initialCollection
            }
            isGetCollectionFinished = true
        } catch {
            log.e(error.localizedDescription)
        }
    }
    
    @MainActor
    func onSelectCollection(id: ID<Domain.Collection>) {
        selectedCollection = collections.first(where: { $0.id == id })
    }
}
