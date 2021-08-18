//
//  FirestoreGetCollection.swift
//  FirestoreGetCollection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import FirebaseFirestoreSwift

struct FirestoreGetCollection: Codable {
    @DocumentID var id: String?
    let name: String
    let colors: [Int]
    let createdAt: Date
}

extension FirestoreGetCollection {
    func toDomain() -> Collection? {
        guard let id = id else { return nil }
        guard colors.count == 3 else { return nil }
        return Collection(
            id: ID<Collection>(value: id),
            name: name,
            color: Collection.RGB(red: colors[0], green: colors[1], blue: colors[2])
        )
    }
}
