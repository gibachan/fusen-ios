//
//  FirestoreGetCollection.swift
//  FirestoreGetCollection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Domain
import Foundation
import SwiftUI

struct FirestoreGetCollection: Codable {
    let color: [Int]
}

extension FirestoreGetCollection {
    func toDomain(id: String) -> Domain.Collection? {
        guard color.count == 3 else { return nil }
        return Domain.Collection(
            id: ID<Domain.Collection>(stringLiteral: id),
            color: RGB(red: color[0], green: color[1], blue: color[2])
        )
    }
}
