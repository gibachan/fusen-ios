//
//  HomeNavigation.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2021/09/15.
//

import Domain
import SwiftUI

enum HomeNavigation {
    case none
    case book(book: Book)
    case allBooks
    case memo(memo: Memo)
    case allMemos
}
