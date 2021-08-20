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
    let name: String
    let color: RGB
    
    struct RGB {
        let red: Int
        let green: Int
        let blue: Int
    }
}

extension Collection {
    static var `default`: Collection {
        Collection(
            id: ID<Collection>(value: ""),
            name: "未分類",
            color: RGB(red: 65, green: 105, blue: 225)
        )
    }
    
    static var sample: Collection {
        Collection(
            id: ID(value: "hoge"),
            name: "ミステリー",
            color: RGB(red: 0, green: 0, blue: 255)
        )
    }
}
