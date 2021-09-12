//
//  URLExtension.swift
//  URLExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import Foundation

extension URL {
    static var term: URL {
        URL(string: "https://fusen.app/term.html")!
    }
    
    static var privacy: URL {
        URL(string: "https://fusen.app/privacy.html")!
    }
}
