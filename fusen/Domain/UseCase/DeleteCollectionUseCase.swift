//
//  DeleteCollectionUseCase.swift
//  DeleteCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum DeleteCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol DeleteCollectionUseCase {
    func invoke(collection: Collection) async throws
}

final class DeleteCollectionUseCaseImpl: DeleteCollectionUseCase {
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    func invoke(collection: Collection) async throws {
        guard let user = accountService.currentUser else {
            throw DeleteCollectionUseCaseError.notAuthenticated
        }
        
        do {
            try await collectionRepository.delete(collection: collection, for: user)
        } catch {
            throw DeleteCollectionUseCaseError.badNetwork
        }
    }
}
