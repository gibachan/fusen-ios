//
//  ImageDataExtension.swift
//  ImageDataExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import UIKit

extension ImageData {
    var uiImage: UIImage? { .init(data: data) }
    
    init?(type: ImageType, uiImage: UIImage) {
        // FIXME: Determine reasonable quality
        let quality: CGFloat
        switch type {
        case .book: quality = 0.8
        case .memo: quality = 0.8
        }
        
        guard let data = uiImage.jpegData(compressionQuality: quality) else {
            return nil
        }
        
        self.type = type
        self.data = data
    }
}
