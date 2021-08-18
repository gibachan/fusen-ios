//
//  BookRepositoryImpl.swift
//  BookRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class BookRepositoryImpl: BookRepository {
    private let db = Firestore.firestore()
    
    // Pagination
    private let perPage = 20
    private var cache: PagerCache<Book> = .empty
    
    func getBook(by id: ID<Book>, for user: User) async throws -> Book {
        let ref = db.booksCollection(for: user)
            .document(id.value)
        do {
            let snapshot = try await ref.getDocument()
            if let getBook = try snapshot.data(as: FirestoreGetBook.self) {
                if let book = getBook.toDomain() {
                    return book
                }
            }
            throw  BookRepositoryError.decodeError
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
    func getLatestBooks(for user: User) async throws -> [Book] {
        let query = db.booksCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: 5)
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            return books
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
    func getBooks(for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        let isCacheValid = cache.currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return cache.currentPager
        }
        
        clearPaginationCache()
        let query = db.booksCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            let finished = books.count < perPage
            let cachedPager = cache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            cache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
    func getNextBooks(for user: User) async throws -> Pager<Book> {
        guard let afterDocument = cache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !cache.currentPager.finished else {
            log.d("All books have been already fetched")
            return cache.currentPager
        }
        
        let query = db.booksCollection(for: user)
            .orderByCreatedAtDesc()
            .start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            let finished = books.count < perPage
            let cachedPager = cache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            cache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
    func addBook(of publication: Publication, for user: User) async throws -> ID<Book> {
        typealias AddBookContinuation = CheckedContinuation<ID<Book>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddBookContinuation) in
            let create = FirestoreCreateBook.fromDomain(publication)
            var ref: DocumentReference?
            ref = db.booksCollection(for: user)
                .addDocument(data: create.data()) { [weak self] error in
                    if let error = error {
                        log.e(error.localizedDescription)
                        continuation.resume(throwing: BookRepositoryError.unknwon)
                        self?.clearPaginationCache()
                    } else {
                        let id = ID<Book>(value: ref!.documentID)
                        continuation.resume(returning: id)
                    }
                }
        }
    }
    
    func update(book: Book, for user: User, isFavorite: Bool) async throws {
        let update = FirestoreUpdateBook(
            title: book.title,
            author: book.author,
            imageURL: book.imageURL?.absoluteString ?? "",
            description: book.description,
            impression: book.impression,
            isFavorite: isFavorite,
            valuation: book.valuation
        )
        let ref = db.booksCollection(for: user)
            .document(book.id.value)
        do {
            try await ref.setData(update.data(), merge: true)
            clearPaginationCache()
        } catch {
            log.e(error.localizedDescription)
            throw BookRepositoryError.unknwon
        }
    }
    
    func delete(book: Book, for user: User) async throws {
        let ref = db.booksCollection(for: user)
            .document(book.id.value)
        do {
            // FIXME: Delete all related memos
            try await ref.delete()
            clearPaginationCache()
        } catch {
            log.e(error.localizedDescription)
            throw BookRepositoryError.unknwon
        }
    }
    
    private func clearPaginationCache() {
        cache = .empty
    }
}
