//
//  Cache.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/05/02.
//

import Foundation

public actor Cache<T> {
    private var cache: [ID<T>: T] = [:]

    public init() {}

    public func get(by id: ID<T>) -> T? {
        cache[id]
    }

    public func set(by id: ID<T>, value: T?) {
        cache[id] = value
    }
}

public let bookCache = Cache<Book>()
public let memoCache = Cache<Memo>()
