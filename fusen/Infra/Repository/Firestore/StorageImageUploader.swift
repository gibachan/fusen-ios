//
//  StorageImageUploader.swift
//  StorageImageUploader
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Foundation
import FirebaseStorage

struct StorageImageUploader {
    func upload(image: ImageData, of bookId: ID<Book>, for user: User) async throws -> URL {
        typealias UploadContinuation = CheckedContinuation<URL, Error>
        return try await withCheckedThrowingContinuation { (continuation: UploadContinuation) in
            let storage = Storage.storage()
            
            let imageName: String
            switch image.type {
            case .book:
                imageName = "book-\(UUID().uuidString).jpg"
                
            case .memo:
                imageName = "memo-\(UUID().uuidString).jpg"
            }
            
            let storagePath = "users/\(user.id.value)/books/\(bookId.value)/\(imageName)"
            let imageRef = storage.reference().child(storagePath)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            log.d("Uploading image..: \(storagePath)")
            imageRef.putData(image.data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    log.e("metadata is missing")
                    continuation.resume(throwing: MemoRepositoryError.uploadImage)
                    return
                }
                log.d("Metadata size=\(metadata.size), content-type=\(metadata.contentType ?? "")")
                imageRef.downloadURL { (url, error) in
                    guard let url = url else {
                        log.e("downloadURL is missing - \(error?.localizedDescription ?? "")")
                        continuation.resume(throwing: MemoRepositoryError.uploadImage)
                        return
                    }
                    log.d("Successfully uploaded: \(url)")
                    continuation.resume(returning: url)
                }
            }
        }
    }
    
}
