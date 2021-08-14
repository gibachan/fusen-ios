//
//  BookRepositoryImpl.swift
//  BookRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    func toBook() -> Book? {
        Book(id: ID<Book>(value: "hoge"), title: "piyo")
    }
}

final class BookRepositoryImpl: BookRepository {
    private let dataSource = FirestoreDataSource()
    
    private let perPage = 20
    private var currentPager = Pager<Book>.empty
    private var lastDocument: DocumentSnapshot?
    
    func getBooks(for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        let isCacheValid = currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return currentPager
        }
        
        let query = dataSource.booksCollection(for: user)
        //                .order(by: "createdAt", descending: true)
        //                .order(by: "title")
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents.compactMap { $0.toBook() }
            let finished = books.count < perPage
            let newPager = Pager<Book>(currentPage: currentPager.currentPage + 1,
                                       finished: finished,
                                       data: currentPager.data + books)
            currentPager = newPager
            lastDocument = snapshot.documents.last
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
    func getNextBooks(for user: User) async throws -> Pager<Book> {
        guard let afterDocument = lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        
        let query = dataSource.booksCollection(for: user)
        //                .order(by: "createdAt", descending: true)
        //                .order(by: "title")
            .start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents.compactMap { $0.toBook() }
            let finished = books.count < perPage
            let newPager = Pager<Book>(currentPage: currentPager.currentPage + 1,
                                       finished: finished,
                                       data: currentPager.data + books)
            currentPager = newPager
            lastDocument = snapshot.documents.last
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
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
                        continuation.resume(throwing: BookRepositoryError.unknwon)
                    } else {
                        let id = ID<Book>(value: ref!.documentID)
                        continuation.resume(returning: id)
                    }
                }
        }
    }
}
