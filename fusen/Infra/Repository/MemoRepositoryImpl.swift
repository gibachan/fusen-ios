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
    private let db = Firestore.firestore()

    // Pagination
    private let perPage = 20
    private var cache: [ID<Book>: PagerCache<Memo>] = [:]

    func getLatestMemos(for user: User) async throws -> [Memo] {
        let query = db.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: 5)
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetMemo.self) }
                .compactMap { $0.toDomain() }
            return memos
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.unknwon
        }
    }
    
    func getMemos(of book: Book, for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        if let cachedPager = cache[book.id]?.currentPager {
            let isCacheValid = cachedPager.data.count >= perPage && !forceRefresh
            if isCacheValid {
                return cachedPager
            }
        }
        
        clearPaginationCache(of: book)
        let query = db.memosCollection(for: user)
            .whereBookId(book)
            .orderByCreatedAtDesc()
            .limit(to: perPage)
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetMemo.self) }
                .compactMap { $0.toDomain() }
            let finished = memos.count < perPage
            let cachedPager = cache[book.id]?.currentPager ?? .empty
            let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + memos)
            cache[book.id] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  BookRepositoryError.unknwon
        }
    }
    
    func getNextMemos(of book: Book, for user: User) async throws -> Pager<Memo> {
        guard let cacheOfBook = cache[book.id] else {
            fatalError("cacheは必ず存在する")

        }
        guard let afterDocument = cacheOfBook.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !cacheOfBook.currentPager.finished else {
            log.d("All memos have been already fetched")
            return cacheOfBook.currentPager
        }
        
        let query = db.memosCollection(for: user)
            .whereBookId(book)
            .orderByCreatedAtDesc()
            .start(afterDocument: afterDocument)
            .limit(to: perPage)
        
        do {
            let snapshot = try await query.getDocuments()
            let memos = snapshot.documents
                .compactMap { try? $0.data(as: FirestoreGetMemo.self) }
                .compactMap { $0.toDomain() }
            let finished = memos.count < perPage
            let cachedPager = cache[book.id]?.currentPager ?? .empty
            let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                       finished: finished,
                                       data: cachedPager.data + memos)
            cache[book.id] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
            return newPager
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.unknwon
        }
    }

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
            ref = db.memosCollection(for: user)
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
    
    private func clearPaginationCache(of book: Book) {
        cache[book.id] = .empty
    }
}
