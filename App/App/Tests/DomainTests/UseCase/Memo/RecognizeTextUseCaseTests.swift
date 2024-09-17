//
//  RecognizeTextUseCaseTests.swift
//  RecognizeTextUseCaseTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/11.
//

import Domain
import XCTest

// class RecognizeTextUseCaseTests: XCTestCase {
//    func testUseVisionTextRecognizeService() async {
//        let visionTextRecognizeService = MockTextRecognizeService(result: "hoge")
//        let useCase = RecognizeTextUseCaseImpl(visionTextRecognizeService: visionTextRecognizeService)
//        let text = await useCase.invoke(imageData: .sample)
//        XCTAssertTrue(visionTextRecognizeService.consumed)
//        XCTAssertEqual(text, "hoge")
//    }
// }
//
// private extension ImageData {
//    static var sample: ImageData {
//        ImageData(type: .book, data: UIImage.actions.jpegData(compressionQuality: 1)!)
//    }
// }
//
// private class MockTextRecognizeService: TextRecognizeServiceProtocol {
//    private let result: String
//    var consumed = false
//    init(result: String) {
//        self.result = result
//    }
//    func text(from image: UIImage) async -> String {
//        consumed = true
//        return result
//    }
// }
