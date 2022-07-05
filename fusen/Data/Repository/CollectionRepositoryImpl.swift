//
//  CollectionRepositoryImpl.swift
//  CollectionRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class CollectionRepositoryImpl: CollectionRepository {
    private let db = Firestore.firestore()
    
    func getlCollections(for user: User) async throws -> [Collection] {
        let query = db.collectionCollection(for: user)
            .orderByCreatedAtDesc()
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e(error.localizedDescription)
            throw  CollectionRepositoryError.network
        }
        return snapshot.documents
            .compactMap { document in
                guard let getCollection = try? document.data(as: FirestoreGetCollection.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getCollection.toDomain(id: document.documentID)
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
                    continuation.resume(throwing: CollectionRepositoryError.network)
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
            throw CollectionRepositoryError.network
        }
    }
}
