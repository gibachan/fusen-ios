//
//  ImageData.swift
//  ImageData
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import Foundation

public struct ImageData {
    public enum ImageType {
        case book
        case memo
        case memoQuote
    }
    public let type: ImageType
    public let data: Data

    public init(type: ImageData.ImageType, data: Data) {
        self.type = type
        self.data = data
    }
}
