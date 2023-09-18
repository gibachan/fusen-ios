//
//  BookSort.swift
//  BookSort
//
//  Created by Tatsuyuki Kobayashi on 2021/09/04.
//

import Foundation

public enum BookSort: String {
    case createdAt = "created_at"
    case title
    case author
}

public extension BookSort {
    static var `default`: BookSort { .createdAt }
}
