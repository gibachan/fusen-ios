//
//  UserRepositoryImpl.swift
//  UserRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Domain
import FirebaseFirestore
import Foundation

public final class UserRepositoryImpl: UserRepository {
    private let database = Firestore.firestore()
    private let dataSource: UserDefaultsDataSource

    public init(dataSource: UserDefaultsDataSource = UserDefaultsDataSourceImpl()) {
        self.dataSource = dataSource
    }

    public func getInfo(for user: User) async throws -> UserInfo {
        let ref = database.userDocument(of: user)
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

    public func update(readingBook book: Book?, for user: User) async throws {
        let update = FirestoreUpdateUser(
            readingBookId: book?.id.value ?? ""
        )
        let ref = database.userDocument(of: user)
        do {
            try await ref.setData(update.data(), merge: true)
            cacheReadingBook(book: book)
        } catch {
            log.e(error.localizedDescription)
            throw UserRepositoryError.network
        }
    }

    private func cacheReadingBook(book: Book?) {
        if let book = book {
            dataSource.readingBook = CachedBook(id: book.id,
                                                title: book.title,
                                                author: book.author,
                                                imageURL: book.imageURL)
        } else {
            dataSource.readingBook = nil
        }
    }
}
