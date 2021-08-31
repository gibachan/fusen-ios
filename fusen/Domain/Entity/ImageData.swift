//
//  ImageData.swift
//  ImageData
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import Foundation

struct ImageData {
    enum ImageType {
        case book
        case memo
        case memoQuote
    }
    let type: ImageType
    let data: Data
}
