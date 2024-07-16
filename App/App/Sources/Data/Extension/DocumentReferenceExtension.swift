//
//  DocumentReferenceExtension.swift
//  DocumentReferenceExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import FirebaseFirestore
import Foundation

extension DocumentReference {
    func getDocumentCachePreferred() async throws -> DocumentSnapshot {
        do {
            let cache = try await getDocument(source: FirestoreSource.cache)
            return cache
        } catch {
            return try await getDocument(source: FirestoreSource.server)
        }
    }
}
