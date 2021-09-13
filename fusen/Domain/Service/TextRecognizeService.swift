//
//  TextRecognizeService.swift
//  TextRecognizeService
//
//  Created by Tatsuyuki Kobayashi on 2021/08/28.
//

import FirebaseFunctions
import MLKit
import MLKitTextRecognitionJapanese
import UIKit

protocol TextRecognizeServiceProtocol {
    func text(from image: UIImage) async -> String
}

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

final class VisionTextRecognizeService: TextRecognizeServiceProtocol {
    private lazy var functions = Functions.functions()
    func text(from image: UIImage) async -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return "" }
        let base64encodedImage = imageData.base64EncodedString()
        
        let requestData: [String: Any] = [
            "image": ["content": base64encodedImage],
            "features": [["type": "DOCUMENT_TEXT_DETECTION"]],
            "imageContext": ["languageHints": ["ja-JP", "en"]]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)
            guard let json = String(bytes: jsonData, encoding: .utf8) else {
                log.e("Failed to covert requestData to json")
                return ""
            }
            
            typealias Continuation = CheckedContinuation<String, Error>
            let result = try await withCheckedThrowingContinuation { (continuation: Continuation) in
                functions.httpsCallable("annotateImage").call(json) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let resultArray = result?.data as? [[String: Any]],
                          let resultData = resultArray.first else {
                              log.e("result data is missing")
                              continuation.resume(returning: "")
                              return
                          }
                    guard let annotation = resultData["fullTextAnnotation"] as? [String: Any] else {
                        log.e("fullTextAnnotation is missing")
                        continuation.resume(returning: "")
                        return
                    }
                    let text = annotation["text"] as? String ?? ""
                    continuation.resume(returning: text)
                }
            }
            return result
        } catch {
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    log.e("FunctionsErrorDomain: code=\(code.debugDescription), message=\(message), details=\(details ?? "")")
                } else {
                    log.e("Unexpected error: \(error.localizedDescription)")
                }
            } else {
                log.e(error.localizedDescription)
            }
            return ""
        }
    }
}
