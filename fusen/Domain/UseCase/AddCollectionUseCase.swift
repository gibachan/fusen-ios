//
//  AddCollectionUseCase.swift
//  AddCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum AddCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol AddCollectionUseCase {
    func invoke(name: String, color: RGB) async throws -> ID<Collection>
}

final class AddCollectionUseCaseImpl: AddCollectionUseCase {
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    func invoke(name: String, color: RGB) async throws -> ID<Collection> {
        guard let user = accountService.currentUser else {
            throw AddCollectionUseCaseError.notAuthenticated
        }
        
        do {
            return try await collectionRepository.addCollection(name: name, color: color, for: user)
        } catch {
            throw AddCollectionUseCaseError.badNetwork
        }
    }
}