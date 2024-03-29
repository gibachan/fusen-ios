//
//  TextRecognizeService.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/09/18.
//

import Domain
import FirebaseFunctions
import Foundation
import UIKit

final class VisionTextRecognizeService: TextRecognizeServiceProtocol {
    private lazy var functions = Functions.functions(region: "asia-northeast1")
    // swiftlint:disable:next cyclomatic_complexity
    func text(from image: UIImage) async -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return "" }
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
                    guard let pages = annotation["pages"] as? [[String: Any]] else { return }
                    var resultText = ""
                    for page in pages {
                        guard let blocks = page["blocks"] as? [[String: Any]] else { continue }
                        for block in blocks {
                            var blockText = ""
                            guard let paragraphs = block["paragraphs"] as? [[String: Any]] else { continue }
                            for paragraph in paragraphs {
                                var paragraphText = ""
                                guard let words = paragraph["words"] as? [[String: Any]] else { continue }
                                for word in words {
                                    var wordText = ""
                                    guard let symbols = word["symbols"] as? [[String: Any]] else { continue }
                                    for symbol in symbols {
                                        let text = symbol["text"] as? String ?? ""
                                        wordText += text
                                    }
                                    paragraphText += wordText
                                }
                                blockText += paragraphText
                            }
                            resultText += blockText
                        }
                    }
                    continuation.resume(returning: resultText)
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
