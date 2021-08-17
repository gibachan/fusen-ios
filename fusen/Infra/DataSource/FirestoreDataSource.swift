//
//  FirestoreDataSource.swift
//  FirestoreDataSource
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import FirebaseFirestore

final class FirestoreDataSource {
    private let db = Firestore.firestore()
    
    func usersCollection() -> CollectionReference {
        return db.collection("users")
    }
    
    func userDocument(of user: User) -> DocumentReference {
        return usersCollection().document(user.id.value)
    }
    
    func booksCollection(for user: User) -> CollectionReference {
        return userDocument(of: user).collection("books")
    }
    
    func bookDocument(of book: Book, for user: User) -> DocumentReference {
        return booksCollection(for: user).document(book.id.value)
    }

    func memosCollection(for user: User) -> CollectionReference {
        return userDocument(of: user).collection("memos")
    }
    
    func memoDocument(of memo: Memo, for user: User) -> DocumentReference {
        return memosCollection(for: user).document(memo.id.value)
    }
}
