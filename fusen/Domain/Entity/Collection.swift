//
//  Collection.swift
//  Collection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

let collectionCountLimit = 20
let collectionBooksCountLimit = 100

struct Collection {
    let id: ID<Collection>
    let color: RGB
    
    var name: String { id.value }
}

extension Collection {
    static var sample: Collection {
        Collection(
            id: ID(value: "ミステリー"),
            color: RGB(red: 0, green: 0, blue: 255)
        )
    }
}
