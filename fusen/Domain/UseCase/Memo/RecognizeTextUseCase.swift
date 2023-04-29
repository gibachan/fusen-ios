//
//  RecognizeTextUseCase.swift
//  RecognizeTextUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

protocol RecognizeTextUseCase {
    func invoke(imageData: ImageData) async -> String
}

final class RecognizeTextUseCaseImpl: RecognizeTextUseCase {
    private let appConfigRepository: AppConfigRepository
    private let visionTextRecognizeService: TextRecognizeServiceProtocol

    init(
        appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl(),
        visionTextRecognizeService: TextRecognizeServiceProtocol = VisionTextRecognizeService()
    ) {
        self.appConfigRepository = appConfigRepository
        self.visionTextRecognizeService = visionTextRecognizeService
    }
    
    func invoke(imageData: ImageData) async -> String {
        guard let image = imageData.uiImage else {
            log.e("uiImage is missing")
            return ""
        }
        return await visionTextRecognizeService.text(from: image)
    }
}
