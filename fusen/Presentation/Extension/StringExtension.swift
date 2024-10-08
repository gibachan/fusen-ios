//
//  StringExtension.swift
//  StringExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/09/04.
//

import Foundation

extension String {
    static var checkMark: String { "✔️" }

    var isNotEmpty: Bool {
        !isEmpty
    }
}
