//
//  MemoSort.swift
//  MemoSort
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum MemoSort {
    case createdAt
    case page
}

extension MemoSort {
    static var `default`: MemoSort { .createdAt }
}
