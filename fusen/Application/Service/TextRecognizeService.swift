//
//  TextRecognizeService.swift
//  TextRecognizeService
//
//  Created by Tatsuyuki Kobayashi on 2021/08/28.
//

import UIKit
import MLKit
import MLKitTextRecognitionJapanese

protocol TextRecognizeServiceProtocol {
    func text(from image: UIImage) async -> String
}

class TextRecognizeService: TextRecognizeServiceProtocol {
    func text(from image: UIImage) async -> String {
        let options = JapaneseTextRecognizerOptions()
        let textRecognizer = TextRecognizer.textRecognizer(options: options)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        do {
            let text = try await textRecognizer.process(visionImage)
            var result = ""
            log.d("block count = \(text.blocks.count)")
            for block in text.blocks {
                // Lines.
                log.d("line count = \(block.lines.count)")
                for line in block.lines {
                    // Elements.
                    log.d("element count = \(line.elements.count)")
                    for element in line.elements {
                        log.d("text = \(element.text)")
                        result += element.text
                    }
                }
            }
            return result
        } catch {
            log.e(error.localizedDescription)
            return ""
        }
    }
}
