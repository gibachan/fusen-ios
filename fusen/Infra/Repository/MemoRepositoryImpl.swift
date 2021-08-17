//
//  MemoRepositoryImpl.swift
//  MemoRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MemoRepositoryImpl: MemoRepository {
    private let dataSource = FirestoreDataSource()
    
    func addMemo(of book: Book, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws -> ID<Memo> {
        typealias AddMemoContinuation = CheckedContinuation<ID<Memo>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddMemoContinuation) in
            let create = FirestoreCreateMemo(
                bookId: book.id.value,
                text: text,
                quote: quote,
                page: page,
                imageURLs: imageURLs.map { $0.absoluteString }
            )
            var ref: DocumentReference?
            ref = dataSource.memosCollection(for: user)
                .addDocument(data: create.data()) { error in
                    if let error = error {
                        log.e(error.localizedDescription)
                        continuation.resume(throwing: MemoRepositoryError.unknwon)
                    } else {
                        let id = ID<Memo>(value: ref!.documentID)
                        continuation.resume(returning: id)
                    }
                }
        }
    }
}
