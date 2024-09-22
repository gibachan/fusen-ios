//
//  MemoRepositoryImpl.swift
//  MemoRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Domain
import FirebaseFirestore
import Foundation

public final class MemoRepositoryImpl: MemoRepository {
    private let database = Firestore.firestore()
    private let dataSource: UserDefaultsDataSource

    // Pagination
    private let perPage = 100
    private var allMemosCache: PagerCache<Memo> = .empty

    private var memosSortedBy: MemoSort = .default
    private var memosCache: [ID<Book>: PagerCache<Memo>] = [:]

    public init(dataSource: UserDefaultsDataSource = UserDefaultsDataSourceImpl()) {
        self.dataSource = dataSource
    }

    public func getDraft() async -> MemoDraft? {
        dataSource.readingBookMemoDraft
    }

    public func setDraft(_ draft: MemoDraft?) async {
        dataSource.readingBookMemoDraft = draft
    }

    public func getMemo(by id: ID<Memo>, for user: User) async throws -> Memo {
        if let cached = await memoCache.get(by: id) {
            return cached
        }

        let ref = database.memosCollection(for: user)
            .document(id.value)
        do {
            let getMemo = try await ref.getDocument(as: FirestoreGetMemo.self)
            let memo = getMemo.toDomain(id: id.value)

            await memoCache.set(by: memo.id, value: memo)

            return memo
        } catch {
            log.e((error as NSError).description)
            throw  MemoRepositoryError.network
        }
    }

    public func getLatestMemos(count: Int, for user: User) async throws -> [Memo] {
        let query = database.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: count)
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }

        return snapshot.documents
            .compactMap { document in
                guard let getMemo = try? document.data(as: FirestoreGetMemo.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getMemo.toDomain(id: document.documentID)
            }
    }

    public func getAllMemos(for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        let isCacheValid = allMemosCache.currentPager.data.count >= perPage && !forceRefresh
        if isCacheValid {
            return allMemosCache.currentPager
        }

        clearAllMemosCache()
        let query = database.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .limit(to: perPage)

        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }

        let memos: [Memo] = snapshot.documents
            .compactMap { document in
                guard let getMemo = try? document.data(as: FirestoreGetMemo.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getMemo.toDomain(id: document.documentID)
            }
        let finished = memos.count < perPage
        let cachedPager = allMemosCache.currentPager
        let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + memos)
        allMemosCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }

    public func getAllMemosNext(for user: User) async throws -> Pager<Memo> {
        guard let afterDocument = allMemosCache.lastDocument else {
            fatalError("lastDocumentは必ず存在する")
        }
        guard !allMemosCache.currentPager.finished else {
            log.d("All memos have been already fetched")
            return allMemosCache.currentPager
        }

        let query = database.memosCollection(for: user)
            .orderByCreatedAtDesc()
            .start(afterDocument: afterDocument)
            .limit(to: perPage)
        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }

        let memos: [Memo] = snapshot.documents
            .compactMap { document in
                guard let getMemo = try? document.data(as: FirestoreGetMemo.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getMemo.toDomain(id: document.documentID)
            }
        let finished = memos.count < perPage
        let cachedPager = allMemosCache.currentPager
        let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + memos)
        allMemosCache = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }

    public func getMemos(of bookId: ID<Book>, sortedBy: MemoSort, for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        if let cachedPager = memosCache[bookId]?.currentPager {
            let isCacheValid = cachedPager.data.count >= perPage && !forceRefresh
            if isCacheValid {
                return cachedPager
            }
        }

        clearCache(of: bookId)
        memosSortedBy = sortedBy

        let memosCollection = database.memosCollection(for: user)
        var query: Query = memosCollection.whereBook(bookId)
        switch memosSortedBy {
        case .createdAt:
            query = query.orderByCreatedAtDesc()
        case .page:
            query = query.orderByPageAsc()
        }
        query = query.limit(to: perPage)

        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }

        let memos: [Memo] = snapshot.documents
            .compactMap { document in
                guard let getMemo = try? document.data(as: FirestoreGetMemo.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getMemo.toDomain(id: document.documentID)
            }
        let finished = memos.count < perPage
        let cachedPager = memosCache[bookId]?.currentPager ?? .empty
        let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + memos)
        memosCache[bookId] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }

    public func getNextMemos(of bookId: ID<Book>, for user: User) async throws -> Pager<Memo> {
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

        let memosCollection = database.memosCollection(for: user)
        var query: Query = memosCollection.whereBook(bookId)
        switch memosSortedBy {
        case .createdAt:
            query = query.orderByCreatedAtDesc()
        case .page:
            query = query.orderByPageAsc()
        }
        query = query
            .start(afterDocument: afterDocument)
            .limit(to: perPage)

        let snapshot: QuerySnapshot
        do {
            snapshot = try await query.getDocuments()
        } catch {
            log.e(error.localizedDescription)
            throw  MemoRepositoryError.network
        }

        let memos: [Memo] = snapshot.documents
            .compactMap { document in
                guard let getMemo = try? document.data(as: FirestoreGetMemo.self) else {
                    log.e("\(document) could not be decoded.")
                    return nil
                }
                return getMemo.toDomain(id: document.documentID)
            }
        let finished = memos.count < perPage
        let cachedPager = memosCache[bookId]?.currentPager ?? .empty
        let newPager = Pager<Memo>(currentPage: cachedPager.currentPage + 1,
                                   finished: finished,
                                   data: cachedPager.data + memos)
        memosCache[bookId] = PagerCache(pager: newPager, lastDocument: snapshot.documents.last)
        return newPager
    }

    public func addMemo(bookId: ID<Book>, text: String, quote: String, page: Int?, image: ImageData?, for user: User) async throws -> ID<Memo> {
        let newMemoDocRef = database.memosCollection(for: user).document()

        var imageURL: URL?
        if let image = image {
            do {
                let storage = ImageStorage()
                imageURL = try await storage.uploadMemo(image: image, memoId: ID<Memo>(stringLiteral: newMemoDocRef.documentID), bookId: bookId, for: user)
            } catch {
                throw MemoRepositoryError.uploadImage
            }
        }

        typealias AddMemoContinuation = CheckedContinuation<ID<Memo>, Error>
        return try await withCheckedThrowingContinuation { (continuation: AddMemoContinuation) in
            let create = FirestoreCreateMemo(
                bookId: bookId.value,
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
                    let id = ID<Memo>(stringLiteral: newMemoDocRef.documentID)
                    continuation.resume(returning: id)
                }
            }
        }
    }

    public func update(memo: Memo, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws {
        let update = FirestoreUpdateMemo(
            text: text,
            quote: quote,
            page: page,
            imageURLs: imageURLs.map { $0.absoluteString }
        )
        let ref = database.memosCollection(for: user)
            .document(memo.id.value)
        do {
            try await ref.setData(update.data(), merge: true)
            clearCache(of: memo.bookId)
            await memoCache.set(by: memo.id, value: nil)
        } catch {
            log.e(error.localizedDescription)
            throw MemoRepositoryError.network
        }
    }

    public func delete(memo: Memo, for user: User) async throws {
        let ref = database.memosCollection(for: user)
            .document(memo.id.value)
        do {
            if let imageURL = memo.imageURLs.first {
                let storage = ImageStorage()
                try await storage.delete(url: imageURL, for: user)
            }

            try await ref.delete()
            clearCache(of: memo.bookId)
            await memoCache.set(by: memo.id, value: nil)
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
