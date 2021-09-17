//
//  AddBookMenuViewModel.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2021/09/17.
//

import Foundation

@MainActor
final class AddBookMenuViewModel: ObservableObject {
    private let initialCollection: Collection?
    private let getCollectionsUseCase: GetCollectionsUseCase
    private var isGetCollectionFinished = false
    
    @Published var collections: [Collection] = []
    @Published var selectedCollection: Collection?
    
    init(
        initialCollection: Collection?,
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl()
    ) {
        self.initialCollection = initialCollection
        self.getCollectionsUseCase = getCollectionsUseCase
    }
    
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
    
    func onSelectCollection(id: ID<Collection>) {
        selectedCollection = collections.first(where: { $0.id == id })
    }
}
