//
//  RecognizeTextUseCase.swift
//  RecognizeTextUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation
import UIKit

public protocol RecognizeTextUseCase {
    func invoke(imageData: ImageData) async -> String
}

public final class RecognizeTextUseCaseImpl: RecognizeTextUseCase {
    private let appConfigRepository: AppConfigRepository
    private let visionTextRecognizeService: TextRecognizeServiceProtocol

    public init(
        appConfigRepository: AppConfigRepository,
        visionTextRecognizeService: TextRecognizeServiceProtocol
    ) {
        self.appConfigRepository = appConfigRepository
        self.visionTextRecognizeService = visionTextRecognizeService
    }

    public func invoke(imageData: ImageData) async -> String {
        guard let image = imageData.uiImage else {
//            log.e("uiImage is missing")
            return ""
        }
        return await visionTextRecognizeService.text(from: image)
    }
}

// FIXME: Remove duplicated code
private extension ImageData {
    var uiImage: UIImage? { .init(data: data) }
}
