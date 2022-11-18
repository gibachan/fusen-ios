//
//  BookRepositoryImpl.swift
//  BookRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class BookRepositoryImpl: BookRepository {
    private let db = Firestore.firestore()
    
    // Pagination
    private let perPage = 100
    private var allBooksSortedBy: BookSort = .default
    private var allBooksCache: PagerCache<Book> = .empty
    private var favoriteBooksCache: PagerCache<Book> = .empty
    
    private var collectionCache: [ID<Collection>: PagerCache<Book>] = [:]
    private var collectionSortedBy: [ID<Collection>: BookSort] = [:]
    
    func getBook(by id: ID<Book>, for user: User) async throws -> Book {
        let ref = db.booksCollection(for: user)
            .document(id.value)
        do {
            let getBook = try await ref.getDocument(as: FirestoreGetBook.self)
            return getBook.toDomain(id: id.value)
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }
    }
    
    func getLatestBooks(count: Int, for user: User) async throws -> [Book] {
        let query = db.booksCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: count)
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        return snapshot.documents
            .compactMap { document in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
    }
    
    func getAllBooks(sortedBy: BookSort, for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        let isCacheValid = allBooksCache.currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return allBooksCache.currentPager
        }
        
        allBooksSortedBy = sortedBy
        clearAllBooksCache()
        
        let booksCollection = db.booksCollection(for: user)
        var query: Query
        switch allBooksSortedBy {
        case .createdAt:
            query = booksCollection.orderByCreatedAtDesc()
        case .title:
            query = booksCollection.orderByTitleAsc()
        case .author:
            query = booksCollection.orderByAuthorAsc()
                .orderByTitleAsc()
        }
        query = query.limit(to: perPage)
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        let books = snapshot.documents
            .compactMap { document -> Book? in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
        let finished = books.count < perPage
        let cachedPager = allBooksCache.currentPager
        let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + books)
        allBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }
    
    func getAllBooksNext(for user: User) async throws -> Pager<Book> {
        guard let afterDocument = allBooksCache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !allBooksCache.currentPager.finished else {
            log.d("All books have been already fetched")
            return allBooksCache.currentPager
        }
        
        let booksCollection = db.booksCollection(for: user)
        var query: Query
        switch allBooksSortedBy {
        case .createdAt:
            query = booksCollection.orderByCreatedAtDesc()
        case .title:
            query = booksCollection.orderByTitleAsc()
        case .author:
            query = booksCollection.orderByAuthorAsc()
        }
        query = query.start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        let books = snapshot.documents
            .compactMap { document -> Book? in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
        let finished = books.count < perPage
        let cachedPager = allBooksCache.currentPager
        let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + books)
        allBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
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
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        let books = snapshot.documents
            .compactMap { document -> Book? in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
        let finished = books.count < perPage
        let cachedPager = favoriteBooksCache.currentPager
        let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + books)
        favoriteBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
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
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        let books = snapshot.documents
            .compactMap { document -> Book? in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
        let finished = books.count < perPage
        let cachedPager = favoriteBooksCache.currentPager
        let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + books)
        favoriteBooksCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }
    
    func getBooks(by collection: Collection, sortedBy: BookSort, for user: User, forceRefresh: Bool) async throws -> Pager<Book> {
        if let cachedPager = collectionCache[collection.id]?.currentPager {
            let isCacheValid = cachedPager.data.count >= perPage && !forceRefresh
            if isCacheValid {
                return cachedPager
            }
        }
        
        collectionSortedBy[collection.id] = sortedBy
        clearCollectionCache(of: collection)
        
        let booksCollection = db.booksCollection(for: user)
        var query = booksCollection.whereCollection(collection)
        switch sortedBy {
        case .createdAt:
            query = query.orderByCreatedAtDesc()
        case .title:
            query = query.orderByTitleAsc()
        case .author:
            query = query.orderByAuthorAsc()
                .orderByTitleAsc()
        }
        query = query.limit(to: perPage)
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        let books = snapshot.documents
            .compactMap { document -> Book? in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
        let finished = books.count < perPage
        let cachedPager = allBooksCache.currentPager
        let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + books)
        collectionCache[collection.id] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }
    
    func getBooksNext(by collection: Collection, for user: User) async throws -> Pager<Book> {
        guard let cache = collectionCache[collection.id] else {
            fatalError("cacheは必ず存在する")
        }
        guard let afterDocument = cache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !cache.currentPager.finished else {
            log.d("Books in \(collection.id.value) have been already fetched")
            return cache.currentPager
        }
        guard let sortedBy = collectionSortedBy[collection.id] else {
            fatalError("sortedBy must be stored for \(collection.id)")
        }
        
        let booksCollection = db.booksCollection(for: user)
        var query = booksCollection.whereCollection(collection)
        switch sortedBy {
        case .createdAt:
            query = query.orderByCreatedAtDesc()
        case .title:
            query = query.orderByTitleAsc()
        case .author:
            query = query.orderByAuthorAsc()
                .orderByTitleAsc()
        }
        query = query.start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e((error as NSError).description)
            throw  BookRepositoryError.network
        }

        let books = snapshot.documents
            .compactMap { document -> Book? in
                guard let getBook = try? document.data(as: FirestoreGetBook.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getBook.toDomain(id: document.documentID)
            }
        let finished = books.count < perPage
        let cachedPager = cache.currentPager
        let newPager = Pager<Book>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + books)
        collectionCache[collection.id] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }
    
    func addBook(of publication: Publication, in collection: Collection?, image: ImageData?, for user: User) async throws -> ID<Book> {
        let newBookDocRef = db.booksCollection(for: user).document()
        let newBookId = ID<Book>(value: newBookDocRef.documentID)
        
        var imageURL: URL?
        if let image = image {
            do {
                let storage = ImageStorage()
                imageURL = try await storage.upload(image: image, bookId: newBookId, for: user)
            } catch {
                throw BookRepositoryError.uploadImage
            }
        }
        
        typealias AddBookContinuation = CheckedContinuation<ID<Book>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddBookContinuation) in
            let create = FirestoreCreateBook.fromDomain(publication: publication, imageURL: imageURL, collection: collection)
            newBookDocRef.setData(create.data(), merge: false) { [weak self] error in
                if let error = error {
                    log.e(error.localizedDescription)
                    continuation.resume(throwing: BookRepositoryError.network)
                    self?.clearAllBooksCache()
                } else {
                    let id = ID<Book>(value: newBookDocRef.documentID)
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
            throw BookRepositoryError.network
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
            throw BookRepositoryError.network
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
            throw BookRepositoryError.network
        }
    }
    
    func update(book: Book, image: ImageData, for user: User) async throws {
        let imageURL: URL
        do {
            let storage = ImageStorage()
            imageURL = try await storage.upload(image: image, bookId: book.id, for: user)
        } catch {
            throw BookRepositoryError.uploadImage
        }
        
        let update = FirestoreUpdateBook(
            title: book.title,
            author: book.author,
            imageURL: imageURL.absoluteString,
            description: book.description,
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
            throw BookRepositoryError.network
        }
    }
    
    func delete(book: Book, for user: User) async throws {
        let memosCollectionRef = db.memosCollection(for: user)
        let memosSnapshot = try await memosCollectionRef
            .whereBook(book.id)
            .getDocuments()
        let memoDocuments = memosSnapshot.documents
        let userRef = db.userDocument(of: user)
        let bookRef = db.booksCollection(for: user)
            .document(book.id.value)
        
        typealias DeleteBookContinuation = CheckedContinuation<Void, Error>
        return try await withCheckedThrowingContinuation { (continuation: DeleteBookContinuation) in
            db.runTransaction { transaction, _ -> Any? in
                if let userSnapshot = try? transaction.getDocument(userRef),
                   userSnapshot.data() != nil,
                   let userInfo = try? userSnapshot.data(as: FirestoreGetUserInfo.self),
                   userInfo.readingBookId == book.id.value {
                    let newUserInfo = FirestoreUpdateUser(readingBookId: "")
                    transaction.setData(newUserInfo.data(), forDocument: userRef, merge: true)
                }
                
                memoDocuments.forEach { memoDocument in
                    let memoRef = memosCollectionRef.document(memoDocument.documentID)
                    transaction.deleteDocument(memoRef)
                }
                transaction.deleteDocument(bookRef)
                return nil
            } completion: { _, error in
                if let error = error {
                    log.e(error.localizedDescription)
                    continuation.resume(throwing: BookRepositoryError.network)
                } else {
                    log.d("Deleted book: \(book.id.value) - \(book.title)")
                    continuation.resume(returning: ())
                }
            }
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
