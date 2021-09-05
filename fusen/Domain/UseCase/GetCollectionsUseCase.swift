//
//  GetCollectionsUseCase.swift
//  GetCollectionsUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetCollectionsUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetCollectionsUseCase {
    func invoke() async throws -> [Collection]
}

final class GetCollectionsUseCaseImpl: GetCollectionsUseCase {
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    func invoke() async throws -> [Collection] {
        guard let user = accountService.currentUser else {
            throw GetCollectionsUseCaseError.notAuthenticated
        }
       
        do {
            return try await collectionRepository.getlCollections(for: user)
        } catch {
            throw GetCollectionsUseCaseError.badNetwork
        }
    }
}
