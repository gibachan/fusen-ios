//
//  Cache.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/05/02.
//

import Foundation

actor Cache<T> {
    private var cache: [ID<T>: T] = [:]

    init() {}

    func get(by id: ID<T>) -> T? {
        cache[id]
    }

    func set(by id: ID<T>, value: T?) {
        cache[id] = value
    }
}

let bookCache = Cache<Book>()
let memoCache = Cache<Memo>()
