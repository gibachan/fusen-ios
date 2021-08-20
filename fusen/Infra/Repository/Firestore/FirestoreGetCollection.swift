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
    let color: [Int]
}

extension FirestoreGetCollection {
    func toDomain() -> Collection? {
        guard let id = id else { return nil }
        guard color.count == 3 else { return nil }
        return Collection(
            id: ID<Collection>(value: id),
            name: name,
            color: RGB(red: color[0], green: color[1], blue: color[2])
        )
    }
}
