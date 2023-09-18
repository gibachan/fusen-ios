//
//  RGB.swift
//  RGB
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import Foundation

public struct RGB {
    // TODO: Use UInt instead of Int
    public let red: Int
    public let green: Int
    public let blue: Int

    public init(
        red: Int,
        green: Int,
        blue: Int
    ) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

public extension RGB {
    var array: [Int] { [red, green, blue] }
}
