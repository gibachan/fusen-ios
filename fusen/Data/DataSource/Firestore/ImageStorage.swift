//
//  ImageStorage.swift
//  ImageStorage
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import FirebaseStorage
import Foundation

enum ImageStorageError: Error {
    case upload
    case delete
}

struct ImageStorage {
    private let storage = Storage.storage()
    
    func upload(image: ImageData, bookId: ID<Book>, for user: User) async throws -> URL {
        let imageName = "book-\(UUID().uuidString).jpg"
        let storagePath = "users/\(user.id.value)/books/\(bookId.value)/\(imageName)"
        return try await upload(image: image, storagePath: storagePath, for: user)
    }
    
    func uploadMemo(image: ImageData, memoId: ID<Memo>, bookId: ID<Book>, for user: User) async throws -> URL {
        let imageName = "memo-\(UUID().uuidString).jpg"
        let storagePath = "users/\(user.id.value)/books/\(bookId.value)/memos/\(memoId.value)/\(imageName)"
        return try await upload(image: image, storagePath: storagePath, for: user)
    }
    
    private func upload(image: ImageData, storagePath: String, for user: User) async throws -> URL {
        typealias UploadContinuation = CheckedContinuation<URL, Error>
        return try await withCheckedThrowingContinuation { (continuation: UploadContinuation) in
            let imageRef = storage.reference().child(storagePath)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            log.d("Uploading image..: \(storagePath)")
            imageRef.putData(image.data, metadata: metadata) { metadata, error in
                if let error = error {
                    log.e(error.localizedDescription)
                    continuation.resume(throwing: ImageStorageError.upload)
                    return
                }
                guard let metadata = metadata else {
                    log.e("metadata is missing")
                    continuation.resume(throwing: ImageStorageError.upload)
                    return
                }
                log.d("Metadata size=\(metadata.size), content-type=\(metadata.contentType ?? "")")
                imageRef.downloadURL { url, error in
                    guard let url = url else {
                        log.e("downloadURL is missing - \(error?.localizedDescription ?? "")")
                        continuation.resume(throwing: ImageStorageError.upload)
                        return
                    }
                    log.d("Successfully uploaded: \(url)")
                    continuation.resume(returning: url)
                }
            }
        }
    }
    
    func delete(url: URL, for user: User) async throws {
        let ref = storage.reference(forURL: url.absoluteString)
        log.d("deleting image..: \(ref) which is from \(url.absoluteString)")
        do {
            try await ref.delete()
            log.d("Successfully deleted: \(url.absoluteString)")
        } catch {
            log.e(error.localizedDescription)
            throw ImageStorageError.delete
        }
    }
}
