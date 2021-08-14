//
//  Pager.swift
//  Pager
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import Foundation

struct Pager<T> {
    let currentPage: Int
    let finished: Bool
    let data: [T]
}

extension Pager {
    static var empty: Pager { .init(currentPage: 0, finished: false, data: []) }
}
