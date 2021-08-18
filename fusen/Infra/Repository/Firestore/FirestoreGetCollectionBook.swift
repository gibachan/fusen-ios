//
//  FirestoreGetCollectionBook.swift
//  FirestoreGetCollectionBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import FirebaseFirestoreSwift

struct FirestoreGetCollectionBook: Codable {
    @DocumentID var id: String?
    let createdAt: Date
}
