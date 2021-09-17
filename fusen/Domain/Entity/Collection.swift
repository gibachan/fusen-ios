//
//  Collection.swift
//  Collection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

struct Collection {
    let id: ID<Collection>
    let color: RGB
    
    var name: String { id.value }
}

extension Collection: Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        lhs.id == rhs.id
    }
}

extension Collection {
    static let countLimit = 20
    
    static var sample: Collection {
        Collection(
            id: ID(value: "ミステリー"),
            color: RGB(red: 0, green: 0, blue: 255)
        )
    }
}
