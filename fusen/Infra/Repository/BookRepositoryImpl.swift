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
    private var allBooksCache: PagerCache<Book> = .empty
    private var favoriteBooksCache: PagerCache<Book> = .empty
    private var collectionCache: [ID<Collection>: PagerCache<Book>] = [:]
    
    func getBook(by id: ID<Book>, for user: User) async throws -> Book {
        let ref = db.booksCollection(for: user)
            .document(id.value)
        do {
            let snapshot = try await ref.getDocument(source: FirestoreSource.cache)
            if let getBook = try snapshot.data(as: FirestoreGetBook.self) {
                if let book = getBook.toDomain() {
                    return book
                }
            }
            throw  BookRepositoryError.decodeError
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknown
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
            throw  BookRepositoryError.unknown
        }
    }
    
    func getAllBooks(for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        let isCacheValid = allBooksCache.currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return allBooksCache.currentPager
        }
        
        clearAllBooksCache()
        let query = db.booksCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            let finished = books.count < perPage
            let cachedPager = allBooksCache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            allBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknown
        }
    }
    
    func getAllBooksNext(for user: User) async throws -> Pager<Book> {
        guard let afterDocument = allBooksCache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !allBooksCache.currentPager.finished else {
            log.d("All books have been already fetched")
            return allBooksCache.currentPager
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
            let cachedPager = allBooksCache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            allBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknown
        }
    }
    
    func getFavoriteBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book> {
        let isCacheValid = favoriteBooksCache.currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return favoriteBooksCache.currentPager
        }
        
        clearFavoriteBooksCache()
        let query = db.booksCollection(for: user)
            .whereIsFavorite(true)
            .orderByCreatedAtDesc()
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            let finished = books.count < perPage
            let cachedPager = favoriteBooksCache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            favoriteBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknown
        }
    }
    
    func getFavoriteBooksNext(for user: User) async throws -> Pager<Book> {
        guard let afterDocument = favoriteBooksCache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !favoriteBooksCache.currentPager.finished else {
            log.d("Favorite books have been already fetched")
            return favoriteBooksCache.currentPager
        }
        
        let query = db.booksCollection(for: user)
            .whereIsFavorite(true)
            .orderByCreatedAtDesc()
            .start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            let finished = books.count < perPage
            let cachedPager = favoriteBooksCache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            favoriteBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknown
        }
    }

    func getBooks(by collection: Collection, for user: User, forceRefresh: Bool) async throws -> Pager<Book> {
        if let cachedPager = collectionCache[collection.id]?.currentPager {
            let isCacheValid = cachedPager.data.count >= perPage && !forceRefresh
            if isCacheValid {
                return cachedPager
            }
        }
        
        clearCollectionCache(of: collection)
        let query = db.booksCollection(for: user)
            .whereCollection(collection)
            .orderByCreatedAtDesc()
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let books = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetBook.self) }
                .compactMap { $0.toDomain() }
            let finished = books.count < perPage
            let cachedPager = allBooksCache.currentPager
            let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + books)
            collectionCache[collection.id] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknown
        }
    }
    
    func addBook(of publication: Publication, in collection: Collection?, for user: User) async throws -> ID<Book> {
        typealias AddBookContinuation = CheckedContinuation<ID<Book>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddBookContinuation) in
            let create = FirestoreCreateBook.fromDomain(publication: publication, collection: collection)
            var ref: DocumentReference?
            ref = db.booksCollection(for: user)
                .addDocument(data: create.data()) { [weak self] error in
                    if let error = error {
                        log.e(error.localizedDescription)
                        continuation.resume(throwing: BookRepositoryError.unknown)
                        self?.clearAllBooksCache()
                    } else {
                        let id = ID<Book>(value: ref!.documentID)
                        continuation.resume(returning: id)
                    }
                }
        }
    }
    
    func update(book: Book, isFavorite: Bool, for user: User ) async throws {
        let update = FirestoreUpdateBook(
            title: book.title,
            author: book.author,
            imageURL: book.imageURL?.absoluteString ?? "",
            description: book.description,
            impression: book.impression,
            isFavorite: isFavorite,
            valuation: book.valuation,
            collectionId: book.collectionId.value
        )
        let ref = db.booksCollection(for: user)
            .document(book.id.value)
        do {
            try await ref.setData(update.data(), merge: true)
            clearAllBooksCache()
        } catch {
            log.e(error.localizedDescription)
            throw BookRepositoryError.unknown
        }
    }
    
    func update(book: Book, title: String, author: String, description: String, for user: User) async throws {
        let update = FirestoreUpdateBook(
            title: title,
            author: author,
            imageURL: book.imageURL?.absoluteString ?? "",
            description: description,
            impression: book.impression,
            isFavorite: book.isFavorite,
            valuation: book.valuation,
            collectionId: book.collectionId.value
        )
        let ref = db.booksCollection(for: user)
            .document(book.id.value)
        do {
            try await ref.setData(update.data(), merge: true)
            clearAllBooksCache()
        } catch {
            log.e(error.localizedDescription)
            throw BookRepositoryError.unknown
        }
    }
    
    func update(book: Book, collection: Collection, for user: User) async throws {
        let update = FirestoreUpdateBook(
            title: book.title,
            author: book.author,
            imageURL: book.imageURL?.absoluteString ?? "",
            description: book.description,
            impression: book.impression,
            isFavorite: book.isFavorite,
            valuation: book.valuation,
            collectionId: collection.id.value
        )
        let ref = db.booksCollection(for: user)
            .document(book.id.value)
        do {
            try await ref.setData(update.data(), merge: true)
            clearAllBooksCache()
        } catch {
            log.e(error.localizedDescription)
            throw BookRepositoryError.unknown
        }
    }
    
    func delete(book: Book, for user: User) async throws {
        let ref = db.booksCollection(for: user)
            .document(book.id.value)
        do {
            // FIXME: Delete all related memos
            try await ref.delete()
            clearAllBooksCache()
        } catch {
            log.e(error.localizedDescription)
            throw BookRepositoryError.unknown
        }
    }
    
    private func clearAllBooksCache() {
        allBooksCache = .empty
    }

    private func clearFavoriteBooksCache() {
        favoriteBooksCache = .empty
    }

    private func clearCollectionCache(of collection: Collection) {
        collectionCache[collection.id] = .empty
    }
}
