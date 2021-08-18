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
