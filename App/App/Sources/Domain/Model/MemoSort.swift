//
//  MemoSort.swift
//  MemoSort
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum MemoSort: String {
    case createdAt = "created_at"
    case page
}

public extension MemoSort {
    static var `default`: MemoSort { .createdAt }
}
