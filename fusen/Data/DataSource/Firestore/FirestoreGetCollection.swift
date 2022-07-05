//
//  FirestoreGetCollection.swift
//  FirestoreGetCollection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import SwiftUI

struct FirestoreGetCollection: Codable {
    let color: [Int]
}

extension FirestoreGetCollection {
    func toDomain(id: String) -> Collection? {
        guard color.count == 3 else { return nil }
        return Collection(
            id: ID<Collection>(value: id),
            color: RGB(red: color[0], green: color[1], blue: color[2])
        )
    }
}
