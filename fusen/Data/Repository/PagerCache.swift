//
//  PagerCache.swift
//  PagerCache
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import FirebaseFirestore
import Foundation

final class PagerCache<T> {
    private(set) var currentPager: Pager<T> = .empty
    private(set) var lastDocument: DocumentSnapshot?

    private init() {}
    
    init(pager: Pager<T>, lastDocument: DocumentSnapshot?) {
        self.currentPager = pager
        self.lastDocument = lastDocument
    }
}

extension PagerCache {
    static var empty: PagerCache<T> { .init() }
}
