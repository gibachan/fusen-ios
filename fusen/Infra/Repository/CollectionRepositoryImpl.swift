//
//  CollectionRepositoryImpl.swift
//  CollectionRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import FirebaseFirestore

final class CollectionRepositoryImpl: CollectionRepository {
    private let db = Firestore.firestore()
    
    func getlCollections(for user: User) async throws -> [Collection] {
        let query = db.collectionCollection(for: user)
            .orderByCreatedAtDesc()
        do {
            let snapshot = try await query.getDocuments()
            let collections = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetCollection.self) }
                .compactMap { $0.toDomain() }
            return collections
        } catch {
            log.e(error.localizedDescription)
            throw  CollectionRepositoryError.unknwon
        }
    }
}
