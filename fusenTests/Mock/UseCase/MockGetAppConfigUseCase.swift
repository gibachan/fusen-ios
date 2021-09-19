//
//  MockGetAppConfigUseCase.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/19.
//

import Foundation
@testable import fusen

final class MockGetAppConfigUseCase: GetAppConfigUseCase {
    let result: AppConfig
    init(_ result: AppConfig) {
        self.result = result
    }

    func invoke() async -> AppConfig {
        result
    }
}
