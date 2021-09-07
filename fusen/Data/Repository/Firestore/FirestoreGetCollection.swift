//
//  FirestoreGetCollection.swift
//  FirestoreGetCollection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import SwiftUI

struct FirestoreGetCollection: Codable {
    let id: String
    let color: [Int]
}

extension FirestoreGetCollection {
    static func from(id: String, data: [String: Any]?) -> Self? {
        guard let data = data else { return nil }
        guard let color = data["color"] as? [Int] else { return nil }
        
        return FirestoreGetCollection(id: id, color: color)
    }
    
    func toDomain() -> Collection? {
        guard color.count == 3 else { return nil }
        return Collection(
            id: ID<Collection>(value: id),
            color: RGB(red: color[0], green: color[1], blue: color[2])
        )
    }
}
