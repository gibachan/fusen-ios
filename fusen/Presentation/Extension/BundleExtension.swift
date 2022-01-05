//
//  BundleExtension.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/04.
//

import Foundation

extension Bundle {
    var shortVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
