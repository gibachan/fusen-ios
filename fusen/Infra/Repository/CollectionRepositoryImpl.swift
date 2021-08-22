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
            throw  CollectionRepositoryError.unknown
        }
    }
    
    func addCollection(name: String, color: RGB, for user: User) async throws -> ID<Collection> {
        typealias AddCollectionContinuation = CheckedContinuation<ID<Collection>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddCollectionContinuation) in
            let create = FirestoreCreateCollection(
                color: color.array
            )
            var ref: DocumentReference?
            ref = db.collectionCollection(for: user)
                .document(name)
            ref?.setData(create.data()) { error in
                if let error = error {
                    log.e(error.localizedDescription)
                    continuation.resume(throwing: CollectionRepositoryError.unknown)
                } else {
                    let id = ID<Collection>(value: ref!.documentID)
                    continuation.resume(returning: id)
                }
            }
        }
    }
    
    func delete(collection: Collection, for user: User) async throws {
        let ref = db.collectionCollection(for: user)
            .document(collection.id.value)
        do {
            try await ref.delete()
        } catch {
            log.e(error.localizedDescription)
            throw CollectionRepositoryError.unknown
        }
    }
}
