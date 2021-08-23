//
//  ImageDataExtension.swift
//  ImageDataExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import UIKit

extension ImageData {
    var uiImage: UIImage? { .init(data: data) }
    
    init?(uiImage: UIImage) {
        // FIXME: Determine reasonable quality
        guard let data = uiImage.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        self.data = data
    }
}
