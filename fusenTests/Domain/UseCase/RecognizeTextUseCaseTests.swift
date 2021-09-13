//
//  RecognizeTextUseCaseTests.swift
//  RecognizeTextUseCaseTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/11.
//

@testable import fusen
import XCTest

class RecognizeTextUseCaseTests: XCTestCase {
    func testUseOnDeviceTextRecognize() async {
        let isVisionAPIUse = false
        let appConfigRepository = MockAppConfigRepository(result: AppConfig(isMaintaining: false, isVisionAPIUse: isVisionAPIUse))
        let onDeviceTextRecognizeService = MockTextRecognizeService(result: "hoge")
        let visionTextRecognizeService = MockTextRecognizeService(result: "piyo")
        let useCase = RecognizeTextUseCaseImpl(appConfigRepository: appConfigRepository, onDeviceTextRecognizeService: onDeviceTextRecognizeService, visionTextRecognizeService: visionTextRecognizeService)
        
        let text = await useCase.invoke(imageData: .sample)
        XCTAssertEqual(text, "hoge")
    }
    func testUseVisionTextRecognizeService() async {
        let isVisionAPIUse = true
        let appConfigRepository = MockAppConfigRepository(result: AppConfig(isMaintaining: false, isVisionAPIUse: isVisionAPIUse))
        let onDeviceTextRecognizeService = MockTextRecognizeService(result: "hoge")
        let visionTextRecognizeService = MockTextRecognizeService(result: "piyo")
        let useCase = RecognizeTextUseCaseImpl(appConfigRepository: appConfigRepository, onDeviceTextRecognizeService: onDeviceTextRecognizeService, visionTextRecognizeService: visionTextRecognizeService)
        
        let text = await useCase.invoke(imageData: .sample)
        XCTAssertEqual(text, "piyo")
    }
}

private extension ImageData {
    static var sample: ImageData {
        ImageData(type: .book, data: UIImage.actions.jpegData(compressionQuality: 1)!)
    }
}

private class MockAppConfigRepository: AppConfigRepository {
    let result: AppConfig
    init(result: AppConfig) {
        self.result = result
    }
    func get() async -> AppConfig { result }
}

private class MockTextRecognizeService: TextRecognizeServiceProtocol {
    let result: String
    init(result: String) {
        self.result = result
    }
    func text(from image: UIImage) async -> String { result }
}
