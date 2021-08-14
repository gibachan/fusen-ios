//
//  BookRepositoryImpl.swift
//  BookRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import FirebaseFirestore

final class BookRepositoryImpl: BookRepository {
    let dataSource = FirestoreDataSource()
    
    func addBook(of publication: Publication, for user: User) async throws -> ID<Book> {
        typealias AddBookContinuation = CheckedContinuation<ID<Book>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddBookContinuation) in
            var ref: DocumentReference?
            ref = dataSource.booksCollection(for: user)
                .addDocument(data: [
                    "title": publication.title
                ]) { error in
                    if let error = error {
                        log.e(error.localizedDescription)
                        continuation.resume(throwing: BookRepositoryError.failedToAddBook)
                    } else {
                        let id = ID<Book>(value: ref!.documentID)
                        continuation.resume(returning: id)
                    }
                }
        }
    }
}

