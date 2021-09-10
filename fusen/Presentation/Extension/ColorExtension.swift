//
//  ColorExtension.swift
//  ColorExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

extension Color {
    // App
//    static let primary = Color("primary")

    // Text
    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color("textSecondary")

    // Button
    static let button = Color("textPrimary")

    // Background
    static let backgroundGray = Color("backgroundGray")
    static let backgroundLightGray = Color("backgroundLightGray")
    static let backgroundSystemGroup = Color(UIColor.systemGroupedBackground)
    
    // Misc
    static let border = Color("border")
    static let info = Color(UIColor.systemGray)
    static let warning = Color(UIColor.systemYellow)
    static let error = Color(UIColor.systemRed)
    static let placeholder = Color("placeholder")
    
    static let active = Color("active")
    static let inactive = Color(UIColor.systemGray)
    static let alert = Color(UIColor.systemRed)
    
    init(rgb: RGB) {
        self.init(red: CGFloat(rgb.red) / 255, green: CGFloat(rgb.green) / 255, blue: CGFloat(rgb.blue) / 255)
    }
    
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
