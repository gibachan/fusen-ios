//
//  GetCollectionsUseCase.swift
//  GetCollectionsUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetCollectionsUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetCollectionsUseCase {
    func invoke() async throws -> [Collection]
}

public final class GetCollectionsUseCaseImpl: GetCollectionsUseCase {
    private let accountService: AccountServiceProtocol
    private let collectionRepository: CollectionRepository
    
    public init(
        accountService: AccountServiceProtocol,
        collectionRepository: CollectionRepository
    ) {
        self.accountService = accountService
        self.collectionRepository = collectionRepository
    }
    
    public func invoke() async throws -> [Collection] {
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
