//
//  IntExtension.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/03/24.
//

import Foundation

extension Int {
    var localizedString: String {
        String.localizedStringWithFormat("%d", self)
    }
}
