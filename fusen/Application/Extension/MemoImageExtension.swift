//
//  MemoImageExtension.swift
//  MemoImageExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import UIKit

extension MemoImage {
    var uiImage: UIImage? { .init(data: data) }
}
