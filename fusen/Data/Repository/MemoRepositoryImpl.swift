//
//  MemoRepositoryImpl.swift
//  MemoRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation
import FirebaseFirestore

final class MemoRepositoryImpl: MemoRepository {
    private let db = Firestore.firestore()
    
    // Pagination
    private let perPage = 100
    private var allMemosCache: PagerCache<Memo> = .empty
    
    private var memosSortedBy: MemoSort = .default
    private var memosCache: [ID<Book>: PagerCache<Memo>] = [:]
    
    func getLatestMemos(count: Int, for user: User) async throws -> [Memo] {
        let query = db.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: count)
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { FirestoreGetMemo.from(id: $0.documentID, data: $0.data()) }
                .compactMap { $0.toDomain() }
            return memos
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }
    }
    
    func getAllMemos(for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        let isCacheValid = allMemosCache.currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return allMemosCache.currentPager
        }
        
        clearAllMemosCache()
        let query = db.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { FirestoreGetMemo.from(id: $0.documentID, data: $0.data()) }
                .compactMap { $0.toDomain() }
            let finished = memos.count < perPage
            let cachedPager = allMemosCache.currentPager
            let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + memos)
            allMemosCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }
    }
    
    func getAllMemosNext(for user: User) async throws -> Pager<Memo> {
        guard let afterDocument = allMemosCache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !allMemosCache.currentPager.finished else {
            log.d("All memos have been already fetched")
            return allMemosCache.currentPager
        }
        
        let query = db.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let memeos = snapshot.documents
                .compactMap { FirestoreGetMemo.from(id: $0.documentID, data: $0.data()) }
                .compactMap { $0.toDomain() }
            let finished = memeos.count < perPage
            let cachedPager = allMemosCache.currentPager
            let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + memeos)
            allMemosCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }
    }
    
    func getMemos(of bookId: ID<Book>, sortedBy: MemoSort, for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        if let cachedPager = memosCache[bookId]?.currentPager {
            let isCacheValid = cachedPager.data.count >= perPage && !forceRefresh
            if isCacheValid {
                return cachedPager
            }
        }
        
        clearCache(of: bookId)
        memosSortedBy = sortedBy
        
        let memos = db.memosCollection(for: user)
        var query: Query = memos.whereBook(bookId)
        switch memosSortedBy {
        case .createdAt:
            query = query.orderByCreatedAtDesc()
        case .page:
            query = query.orderByPageAsc()
        }
        query = query.limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { FirestoreGetMemo.from(id: $0.documentID, data: $0.data()) }
                .compactMap { $0.toDomain() }
            let finished = memos.count < perPage
            let cachedPager = memosCache[bookId]?.currentPager ?? .empty
            let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + memos)
            memosCache[bookId] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }
    }
    
    func getNextMemos(of bookId: ID<Book>, for user: User) async throws -> Pager<Memo> {
        guard let cacheOfBook = memosCache[bookId] else {
            fatalError("cacheは必ず存在する")
            
        }
        guard let afterDocument = cacheOfBook.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !cacheOfBook.currentPager.finished else {
            log.d("All memos have been already fetched")
            return cacheOfBook.currentPager
        }
        
        let memos = db.memosCollection(for: user)
        var query: Query = memos.whereBook(bookId)
        switch memosSortedBy {
        case .createdAt:
            query = query.orderByCreatedAtDesc()
        case .page:
            query = query.start(afterDocument: afterDocument)
                .orderByPageAsc()
        }
        query = query.limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { FirestoreGetMemo.from(id: $0.documentID, data: $0.data()) }
                .compactMap { $0.toDomain() }
            let finished = memos.count < perPage
            let cachedPager = memosCache[bookId]?.currentPager ?? .empty
            let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + memos)
            memosCache[bookId] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }
    }
    
    func addMemo(of book: Book, text: String, quote: String, page: Int?, image: ImageData?, for user: User) async throws -> ID<Memo> {
        let newMemoDocRef = db.memosCollection(for: user).document()

        var imageURL: URL?
        if let image = image {
            do {
                let storage = ImageStorage()
                imageURL = try await storage.uploadMemo(image: image, memoId: ID<Memo>(value: newMemoDocRef.documentID), bookId: book.id, for: user)
            } catch {
                throw MemoRepositoryError.uploadImage
            }
        }
        
        typealias AddMemoContinuation = CheckedContinuation<ID<Memo>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddMemoContinuation) in
            let create = FirestoreCreateMemo(
                bookId: book.id.value,
                text: text,
                quote: quote,
                page: page,
                imageURLs: imageURL != nil ? [imageURL!.absoluteString] : []
            )
            newMemoDocRef.setData(create.data(), merge: false) { error in
                if let error = error {
                    log.e(error.localizedDescription)
                    continuation.resume(throwing: MemoRepositoryError.network)
                } else {
                    let id = ID<Memo>(value: newMemoDocRef.documentID)
                    continuation.resume(returning: id)
                }
            }
        }
    }
    
    func update(memo: Memo, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws {
        let update = FirestoreUpdateMemo(
            text: text,
            quote: quote,
            page: page,
            imageURLs: imageURLs.map { $0.absoluteString }
        )
        let ref = db.memosCollection(for: user)
            .document(memo.id.value)
        do {
            try await ref.setData(update.data(), merge: true)
            clearCache(of: memo.bookId)
        } catch {
            log.e(error.localizedDescription)
            throw MemoRepositoryError.network
        }
    }
    
    func delete(memo: Memo, for user: User) async throws {
        let ref = db.memosCollection(for: user)
            .document(memo.id.value)
        do {
            if let imageURL = memo.imageURLs.first {
                let storage = ImageStorage()
                try await storage.delete(url: imageURL, for: user)
            }

            try await ref.delete()
            clearCache(of: memo.bookId)
        } catch {
            log.e(error.localizedDescription)
            throw MemoRepositoryError.network
        }
    }
    
    private func clearAllMemosCache() {
        allMemosCache = .empty
    }
    
    private func clearCache(of bookId: ID<Book>) {
        memosCache[bookId] = .empty
    }
}
