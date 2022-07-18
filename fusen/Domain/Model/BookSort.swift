//
//  BookSort.swift
//  BookSort
//
//  Created by Tatsuyuki Kobayashi on 2021/09/04.
//

import Foundation

enum BookSort: String {
    case createdAt = "created_at"
    case title
    case author
}

extension BookSort {
    static var `default`: BookSort { .createdAt }
}
