//
//  MemoRepositoryImpl.swift
//  MemoRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

final class MemoRepositoryImpl: MemoRepository {
    private let db = Firestore.firestore()
    
    // Pagination
    private let perPage = 20
    private var allMemosCache: PagerCache<Memo> = .empty
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
                .compactMap { try? $0.data(as: FirestoreGetMemo.self) }
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
            throw  MemoRepositoryError.unknwon
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
                .compactMap { try? $0.data(as: FirestoreGetMemo.self) }
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
        
        clearCache(of: book)
        let query = db.memosCollection(for: user)
            .whereBook(book)
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
            .whereBook(book)
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
    
    func addMemo(of book: Book, text: String, quote: String, page: Int?, image: MemoImage?, for user: User) async throws -> ID<Memo> {
        
        var imageURL: URL? = nil
        if let image = image {
            do {
                imageURL = try await upload(image: image, of: book, for: user)
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
    
    private func upload(image: MemoImage, of book: Book, for user: User) async throws -> URL {
        typealias UploadContinuation = CheckedContinuation<URL, Error>
        return try await withCheckedThrowingContinuation { (continuation: UploadContinuation) in
            let storage = Storage.storage()
            let imageName = "\(UUID().uuidString).jpg"
            let storagePath = "users/\(user.id.value)/books/\(book.id.value)/\(imageName)"
            let imageRef = storage.reference().child(storagePath)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            log.d("Uploading image..: \(storagePath)")
            let _ = imageRef.putData(image.data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    log.e("metadata is missing")
                    continuation.resume(throwing: MemoRepositoryError.uploadImage)
                    return
                }
                log.d("Metadata size=\(metadata.size), content-type=\(metadata.contentType ?? "")")
                imageRef.downloadURL { (url, error) in
                    guard let url = url else {
                        log.e("downloadURL is missing")
                        continuation.resume(throwing: MemoRepositoryError.uploadImage)
                        return
                    }
                    log.d("Successfully uploaded: \(url)")
                    continuation.resume(returning: url)
                }
            }
        }
    }
    
    func update(memo: Memo, of book: Book, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws {
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
            clearCache(of: book)
        } catch {
            log.e(error.localizedDescription)
            throw MemoRepositoryError.unknwon
        }
    }
    
    func delete(memo: Memo, of book: Book, for user: User) async throws {
        let ref = db.memosCollection(for: user)
            .document(memo.id.value)
        do {
            try await ref.delete()
            clearCache(of: book)
        } catch {
            log.e(error.localizedDescription)
            throw MemoRepositoryError.unknwon
        }
    }
    
    private func clearAllMemosCache() {
        allMemosCache = .empty
    }
    
    private func clearCache(of book: Book) {
        cache[book.id] = .empty
    }
}
