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
    private let onDeviceTextRecognizeService: TextRecognizeServiceProtocol
    private let visionTextRecognizeService: TextRecognizeServiceProtocol

    init(
        appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl(),
        onDeviceTextRecognizeService: TextRecognizeServiceProtocol = OnDeviceTextRecognizeService(),
        visionTextRecognizeService: TextRecognizeServiceProtocol = VisionTextRecognizeService()
    ) {
        self.appConfigRepository = appConfigRepository
        self.onDeviceTextRecognizeService = onDeviceTextRecognizeService
        self.visionTextRecognizeService = visionTextRecognizeService
    }
    
    func invoke(imageData: ImageData) async -> String {
        guard let image = imageData.uiImage else {
            log.e("uiImage is missing")
            return ""
        }
        let config = await appConfigRepository.get()
        let textRecognizeService: TextRecognizeServiceProtocol
        if config.isVisionAPIUse {
            log.d("Use VisionTextRecognizeService")
            textRecognizeService = visionTextRecognizeService
        } else {
            log.d("Use OnDeviceTextRecognizeService")
            textRecognizeService = onDeviceTextRecognizeService
        }
        return await textRecognizeService.text(from: image)
    }
}
