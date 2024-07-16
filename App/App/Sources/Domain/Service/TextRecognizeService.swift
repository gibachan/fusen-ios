//
//  TextRecognizeService.swift
//  TextRecognizeService
//
//  Created by Tatsuyuki Kobayashi on 2021/08/28.
//

import UIKit

public protocol TextRecognizeServiceProtocol {
    func text(from image: UIImage) async -> String
}

/**
final class OnDeviceTextRecognizeService: TextRecognizeServiceProtocol {
    func text(from image: UIImage) async -> String {
        let options = JapaneseTextRecognizerOptions()
        let textRecognizer = TextRecognizer.textRecognizer(options: options)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation

        do {
            let result = try await textRecognizer.process(visionImage)
            return result.text
        } catch {
            log.e(error.localizedDescription)
            return ""
        }
    }
}
*/
