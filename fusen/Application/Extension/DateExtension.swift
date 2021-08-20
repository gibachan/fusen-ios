//
//  DateExtension.swift
//  DateExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
}()

extension Date {
    var string: String { formatter.string(from: self) }
}
