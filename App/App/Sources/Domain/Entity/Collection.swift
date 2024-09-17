//
//  Collection.swift
//  Collection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

public struct Collection {
    public let id: ID<Collection>
    public let color: RGB

    public var name: String { id.value }

    public init(
        id: ID<Collection>,
        color: RGB
    ) {
        self.id = id
        self.color = color
    }
}

extension Collection: Equatable {
    public static func == (lhs: Collection, rhs: Collection) -> Bool {
        lhs.id == rhs.id
    }
}

public extension Collection {
    static let countLimit = 20

    static var sample: Collection {
        Collection(
            id: ID(value: "ミステリー"),
            color: RGB(red: 0, green: 0, blue: 255)
        )
    }
}
