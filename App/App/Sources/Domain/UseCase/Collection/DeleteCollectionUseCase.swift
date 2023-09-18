//
//  DeleteCollectionUseCase.swift
//  DeleteCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum DeleteCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol DeleteCollectionUseCase {
    func invoke(collection: Collection) async throws
}

public final class DeleteCollectionUseCaseImpl: DeleteCollectionUseCase {
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    public init(
        accountService: AccountServiceProtocol,
        collectionRepository: CollectionRepository
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    public func invoke(collection: Collection) async throws {
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
