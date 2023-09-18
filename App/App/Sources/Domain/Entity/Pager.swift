//
//  Pager.swift
//  Pager
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import Foundation

public struct Pager<T> {
    public let currentPage: Int
    public let finished: Bool
    public let data: [T]

    public init(currentPage: Int, finished: Bool, data: [T]) {
        self.currentPage = currentPage
        self.finished = finished
        self.data = data
    }
}

public extension Pager {
    static var empty: Pager { .init(currentPage: 0, finished: false, data: []) }
}
