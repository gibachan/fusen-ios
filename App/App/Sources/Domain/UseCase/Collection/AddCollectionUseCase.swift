//
//  AddCollectionUseCase.swift
//  AddCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum AddCollectionUseCaseError: Error {
    case notAuthenticated
    case countOver
    case badNetwork
}

public protocol AddCollectionUseCase {
    func invoke(name: String, color: RGB) async throws -> ID<Collection>
}

public final class AddCollectionUseCaseImpl: AddCollectionUseCase {
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    public init(
        accountService: AccountServiceProtocol,
        collectionRepository: CollectionRepository
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    public func invoke(name: String, color: RGB) async throws -> ID<Collection> {
        guard let user = accountService.currentUser else {
            throw AddCollectionUseCaseError.notAuthenticated
        }

        let collections: [Collection]
        do {
            collections = try await collectionRepository.getlCollections(for: user)
        } catch {
            throw AddCollectionUseCaseError.badNetwork
        }
        
        guard collections.count < Collection.countLimit else {
            throw AddCollectionUseCaseError.countOver
        }

        do {
            return try await collectionRepository.addCollection(name: name, color: color, for: user)
        } catch {
            throw AddCollectionUseCaseError.badNetwork
        }
    }
}
