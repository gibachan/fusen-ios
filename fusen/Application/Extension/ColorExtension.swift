//
//  ColorExtension.swift
//  ColorExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

extension Color {
    // App
    static let primary = Color("primary")

    // Text
    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color("textSecondary")

    // Button
    static let button = Color("textPrimary")

    // Background
    static let backgroundGray = Color("backgroundGray")
    static let backgroundLightGray = Color("backgroundLightGray")
    
    // Misc
    static let info = Color.gray
    static let warning = Color.yellow
    static let error = Color.red
    static let placeholder = Color("placeholder")
    static let inactive = Color.gray
    
    func rgb() -> RGB? {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        return RGB(red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255))
    }
}
