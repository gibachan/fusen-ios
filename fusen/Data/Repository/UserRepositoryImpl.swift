//
//  UserRepositoryImpl.swift
//  UserRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class UserRepositoryImpl: UserRepository {
    private let db = Firestore.firestore()
    
    func getInfo(for user: User) async throws -> UserInfo {
        let ref = db.userDocument(of: user)
        let snapshot: DocumentSnapshot
        do {
            snapshot = try await ref.getDocument()
        } catch {
            log.e((error as NSError).description)
            throw  UserRepositoryError.network
        }
        if snapshot.data() == nil {
            // フィールドが存在しない場合は `data() == nil` となる
            return .none
        } else if let getUserInfo = try? snapshot.data(as: FirestoreGetUserInfo.self) {
            return getUserInfo.toDomain()
        }
        throw  UserRepositoryError.network
    }

    func update(readingBook book: Book?, for user: User) async throws {
        let update = FirestoreUpdateUser(
            readingBookId: book?.id.value ?? ""
        )
        let ref = db.userDocument(of: user)
        do {
            try await ref.setData(update.data(), merge: true)
        } catch {
            log.e(error.localizedDescription)
            throw UserRepositoryError.network
        }
    }
}
